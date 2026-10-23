page 83801 "bri_ComptoirSalesDataList"
{
    Caption = 'Données de vente Comptoir';
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "bri_ComptoirSalesData";
    CardPageId = "bri_ComptoirSalesDataCard";
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = true;

    layout
    {
        area(Content)
        {
            repeater(Records)
            {
                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; }
                field("Point Of Sale"; Rec."Point Of Sale") { ApplicationArea = All; }
                field("External Document No."; Rec."External Document No.") { ApplicationArea = All; }
                field("Document Type"; Rec."Document Type") { ApplicationArea = All; }
                field("Received At"; Rec."Received At") { ApplicationArea = All; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Error Message"; Rec."Error Message") { ApplicationArea = All; }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(ImportOrder)
            {
                ApplicationArea = All;
                Caption = 'Importer la commande';
                ToolTip = 'Crée la commande vente (en-tête, lignes et commentaires) à partir des données Comptoir reçues.';
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    ImportMgt.ImportEntryWithConfirm(Rec."Entry No.");
                    CurrPage.Update(false);
                end;
            }
        }
    }

    var
        ImportMgt: Codeunit "bri_ComptoirStagingAPIJob";
}
