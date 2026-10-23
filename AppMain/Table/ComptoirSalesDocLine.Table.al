table 83802 "bri_ComptoirSalesDocLine"
{
    Caption = 'Ligne document vente Comptoir';
    TableType = Temporary;

    fields
    {
        field(1; "Seq. No."; Integer) { Caption = 'N° séquence'; }
        field(2; "Line No."; Integer) { Caption = 'N° ligne'; }
        field(3; Type; Text[20]) { Caption = 'Type'; }
        field(4; "No."; Code[20]) { Caption = 'N°'; }
        field(5; Description; Text[100]) { Caption = 'Description'; }
        field(6; "Location Code"; Code[20]) { Caption = 'Code magasin'; }
        field(7; "Bin Code"; Code[20]) { Caption = 'Code emplacement'; }
        field(8; Quantity; Decimal) { Caption = 'Quantité'; }
        field(9; "Free Quantity"; Decimal) { Caption = 'Quantité gratuite'; }
        field(10; "Free Nature Code"; Code[20]) { Caption = 'Code nature gratuité'; }
        field(11; "Qty. Shipped"; Decimal) { Caption = 'Qté expédiée'; }
        field(12; "Qty. Invoiced"; Decimal) { Caption = 'Qté facturée'; }
        field(13; "Unit Price"; Decimal) { Caption = 'Prix unitaire'; }
        field(14; "Operation Code"; Code[20]) { Caption = 'Code opération'; }
        field(15; "Sub-Operation Code"; Code[20]) { Caption = 'Code sous-opération'; }
        field(16; "Your Reference"; Text[100]) { Caption = 'Votre référence'; }
        field(17; "Lot No."; Code[50]) { Caption = 'N° lot'; }
        field(18; "Serial No."; Code[50]) { Caption = 'N° série'; }
    }

    keys
    {
        key(PK; "Seq. No.") { Clustered = true; }
    }
}
