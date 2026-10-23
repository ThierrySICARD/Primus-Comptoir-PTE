table 83800 "bri_ComptoirSalesData"
{
    Caption = 'Données de vente Comptoir';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'N° séquence'; AutoIncrement = true; ToolTip = 'N° de séquence de l''import brut du ticket'; }
        field(2; "Point Of Sale"; Code[20]) { Caption = 'Code Comptoir'; }
        field(3; "External Document No."; Code[35]) { Caption = 'N° document externe'; ToolTip = 'N° du document externe. Correspond au N° de ticket Comptoir'; }
        field(4; "Document Type"; Text[30]) { Caption = 'Type document'; }
        field(5; "Raw JSON"; Blob) { Caption = 'Raw JSON'; }
        field(6; "Received At"; DateTime) { Caption = 'Date réception Ticket'; ToolTip = 'Date et heure de réception du ticket'; }
        field(7; Status; Option) { Caption = 'Statut'; OptionMembers = New,Processed,Error; OptionCaption = 'Nouveau,Traité,Erreur'; }
        field(8; "Error Message"; Text[250]) { Caption = 'Message d''erreur'; }
        field(9; "Document No."; Code[20]) { Caption = 'N° document'; }
        field(10; "Processed DateTime"; DateTime) { Caption = 'Date traitement'; ToolTip = 'Date et heure du traitement d''intégration'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
        key(PointOfSale; "Point Of Sale") { }
        key(ExtDoc; "External Document No.") { }
    }

    procedure SetRawJson(Value: Text)
    var
        OutStr: OutStream;
    begin
        Clear("Raw JSON");
        "Raw JSON".CreateOutStream(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(Value);
    end;

    procedure GetRawJson() Value: Text
    var
        InStr: InStream;
        Line: Text;
    begin
        CalcFields("Raw JSON");
        "Raw JSON".CreateInStream(InStr, TextEncoding::UTF8);
        while not InStr.EOS do begin
            InStr.ReadText(Line);
            Value += Line;
        end;
    end;
}