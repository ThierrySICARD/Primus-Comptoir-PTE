codeunit 83801 bri_ComptoirStagingAPIJob
{
    trigger OnRun()
    var
        Entry: Record bri_ComptoirSalesData;
        EntryNos: List of [Integer];
        EntryNo: Integer;
    begin
        Entry.SetCurrentKey(Status, "Entry No.");
        Entry.SetRange(Status, Entry.Status::New);
        if Entry.FindSet() then
            repeat
                EntryNos.Add(Entry."Entry No.");
            until Entry.Next() = 0;

        foreach EntryNo in EntryNos do
            ProcessEntry(EntryNo);
    end;

    procedure ImportEntryWithConfirm(EntryNo: Integer)
    var
        Entry: Record bri_ComptoirSalesData;
    begin
        Entry.Get(EntryNo);
        if Entry.Status = Entry.Status::Processed then
            Error('Entry %1 has already been imported (document %2).', EntryNo, Entry."Document No.");
        if not Confirm('Voulez vous importer le Ticket Comptoir %1 en tant que commande de vente?', false, EntryNo) then
            exit;

        if ProcessEntry(EntryNo) then begin
            Entry.Get(EntryNo);
            Message('Commande Vente %1 créée.', Entry."Document No.");
        end else begin
            Entry.Get(EntryNo);
            Error('%1', Entry."Error Message");
        end;
    end;

    // Crée et traite une entrée Comptoir en tant que commande de vente
    procedure ProcessEntry(EntryNo: Integer): Boolean
    var
        Entry: Record bri_ComptoirSalesData;
        Success: Boolean;
    begin
        Commit();
        Entry.Get(EntryNo);
        ClearLastError();
        Success := Codeunit.Run(Codeunit::bri_ComptoirStagingAPIProcess, Entry);
        if not Success then begin
            Entry.Get(EntryNo);
            Entry.Status := Entry.Status::Error;
            Entry."Error Message" := CopyStr(GetLastErrorText(), 1, MaxStrLen(Entry."Error Message"));
            Entry."Processed DateTime" := CurrentDateTime();
            Entry.Modify();
        end;
        Commit();
        exit(Success);
    end;
}
