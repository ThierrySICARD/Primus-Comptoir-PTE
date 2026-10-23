table 83803 "bri_ComptoirSalesDocComment"
{
    Caption = 'Commentaire document vente Comptoir';
    TableType = Temporary;

    fields
    {
        field(1; "Seq. No."; Integer) { Caption = 'N° séquence'; }
        field(2; "Line No."; Integer) { Caption = 'N° ligne'; }
        field(3; Rank; Integer) { Caption = 'Rang'; }
        field(4; Location; Text[50]) { Caption = 'Emplacement'; }
        field(5; Comment; Text[250]) { Caption = 'Commentaire'; }
        field(6; Preparation; Boolean) { Caption = 'Préparation'; }
        field(7; Transport; Boolean) { Caption = 'Transport'; }
        field(8; Invoicing; Boolean) { Caption = 'Facturation'; }
        field(9; "Production Order"; Boolean) { Caption = 'Ordre de fabrication'; }
        field(10; "Exclude From Invoice"; Boolean) { Caption = 'Exclure de la facture'; }
    }

    keys
    {
        key(PK; "Seq. No.") { Clustered = true; }
    }
}
