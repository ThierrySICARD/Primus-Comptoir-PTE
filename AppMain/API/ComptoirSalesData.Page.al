page 83800 "bri_ComptoirSalesData"
{
    PageType = API;
    APIPublisher = 'PrimusAPI';
    APIGroup = 'comptoir';
    APIVersion = 'v2.0';
    EntityName = 'comptoirSalesData';
    EntitySetName = 'comptoirSalesDatas';
    SourceTable = "bri_ComptoirSalesData";
    ODataKeyFields = SystemId;
    DelayedInsert = true;
    InsertAllowed = true;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field(id; Rec.SystemId) { Editable = false; }
                field(PointOfSale; Rec."Point Of Sale") { }
                field(entryNo; Rec."Entry No.") { Editable = false; }
                field(externalDocumentNo; Rec."External Document No.") { }
                field(documentType; Rec."Document Type") { }
                field(rawJson; RawJsonTxt) { }
                field(receivedAt; Rec."Received At") { Editable = false; }
                field(status; Rec.Status) { }
                field(errorMessage; Rec."Error Message") { }
            }
        }
    }

    var
        DataMgt: Codeunit "bri_ComptoirSalesDataMgt";
        RawJsonTxt: Text;

    trigger OnAfterGetRecord()
    begin
        RawJsonTxt := Rec.GetRawJson();
    end;

    trigger OnModifyRecord(): Boolean
    begin
        if RawJsonTxt <> Rec.GetRawJson() then begin
            DataMgt.ValidatePayload(RawJsonTxt);
            Rec.SetRawJson(RawJsonTxt);
        end;
        exit(true);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    var
        JObj: JsonObject;
        JTok: JsonToken;
        LR_SalesHeader: Record "Sales Header";
        L_IsOrderComptoir: Boolean;
        YourRef: Text;
        L_textError: Text;
        Text001_Err: Label 'La commande pour la référence %1 existe déjà', Comment = '%1 = PWS';

    begin
        // Lecture du JSON brut pour validation et extraction des clés
        DataMgt.ValidatePayload(RawJsonTxt);
        JObj.ReadFrom(RawJsonTxt);

        Rec.SetRawJson(RawJsonTxt);

        Rec."Received At" := CurrentDateTime();

        // Fill keys from the payload when the caller didn't send them
        if (Rec."External Document No." = '') and JObj.Get('externalDocumentNo', JTok) then
            Rec."External Document No." := CopyStr(JTok.AsValue().AsText(), 1, MaxStrLen(Rec."External Document No."));
        if (Rec."Document Type" = '') and JObj.Get('documentType', JTok) then
            Rec."Document Type" := CopyStr(JTok.AsValue().AsText(), 1, MaxStrLen(Rec."Document Type"));
        if (Rec."Point Of Sale" = '') and JObj.Get('pointOfSale', JTok) then
            Rec."Point Of Sale" := CopyStr(JTok.AsValue().AsText(), 1, MaxStrLen(Rec."Point Of Sale"));
        exit(true);
    end;
}