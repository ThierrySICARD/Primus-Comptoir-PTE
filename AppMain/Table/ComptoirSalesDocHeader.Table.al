table 83801 "bri_ComptoirSalesDocHeader"
{
    Caption = 'En-tête document vente Comptoir';
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer) { Caption = 'N° séquence'; }
        field(2; "Document Type"; Text[30]) { Caption = 'Type document'; }
        field(3; "No."; Code[20]) { Caption = 'N°'; }
        field(4; "Creation Date"; Date) { Caption = 'Date création'; }
        field(5; "Order Type"; Code[20]) { Caption = 'Type commande'; }
        field(6; "Team"; Code[20]) { Caption = 'Équipe'; }

        field(10; "Sell-to Customer No."; Code[20]) { Caption = 'Donneur d''ordre N°'; }
        field(11; "Sell-to Customer Name"; Text[100]) { Caption = 'Donneur d''ordre nom'; }
        field(12; "Sell-to Address"; Text[100]) { Caption = 'Donneur d''ordre adresse'; }
        field(13; "Sell-to Address 2"; Text[50]) { Caption = 'Donneur d''ordre adresse (2ème ligne)'; }
        field(14; "Sell-to City"; Text[50]) { Caption = 'Donneur d''ordre ville'; }
        field(15; "Sell-to Post Code"; Code[20]) { Caption = 'Donneur d''ordre code postal'; }
        field(16; "Sell-to Country/Region Code"; Code[10]) { Caption = 'Donneur d''ordre code pays/région'; }

        field(20; "Bill-to Customer No."; Code[20]) { Caption = 'Facturation N° client'; }
        field(21; "Bill-to Name"; Text[100]) { Caption = 'Facturation nom'; }
        field(22; "Bill-to Address"; Text[100]) { Caption = 'Facturation adresse'; }
        field(23; "Bill-to Address 2"; Text[50]) { Caption = 'Facturation adresse (2ème ligne)'; }
        field(24; "Bill-to City"; Text[50]) { Caption = 'Facturation ville'; }
        field(25; "Bill-to Post Code"; Code[20]) { Caption = 'Facturation code postal'; }
        field(26; "Bill-to Country/Region Code"; Code[10]) { Caption = 'Facturation code pays/région'; }

        field(30; "Ship-to Code"; Code[20]) { Caption = 'Livraison code'; }
        field(31; "Ship-to Name"; Text[100]) { Caption = 'Livraison nom'; }
        field(32; "Ship-to Address"; Text[100]) { Caption = 'Livraison adresse'; }
        field(33; "Ship-to Address 2"; Text[50]) { Caption = 'Livraison adresse (2ème ligne)'; }
        field(34; "Ship-to City"; Text[50]) { Caption = 'Livraison ville'; }
        field(35; "Ship-to Post Code"; Code[20]) { Caption = 'Livraison code postal'; }
        field(36; "Ship-to Country/Region Code"; Code[10]) { Caption = 'Livraison code pays/région'; }

        field(40; "Payment Method Code"; Code[20]) { Caption = 'Code mode de règlement'; }
        field(41; "Payment Terms Code"; Code[20]) { Caption = 'Code condition de paiement'; }
        field(42; "Prices Including VAT"; Boolean) { Caption = 'Prix TTC'; }
        field(43; "Shipment Method Code"; Code[20]) { Caption = 'Code condition de livraison'; }
        field(44; "Shipping Agent Code"; Code[20]) { Caption = 'Code transporteur'; }
        field(45; "Shipping Time"; Text[30]) { Caption = 'Délai de livraison'; }
        field(46; "Requested Delivery Date"; Date) { Caption = 'Date livraison demandée'; }
        field(47; "Promised Delivery Date"; Date) { Caption = 'Date livraison confirmée'; }
        field(48; "Delivery Time"; Time) { Caption = 'Heure de livraison'; }
        field(49; "Deposit"; Decimal) { Caption = 'Acompte'; }
        field(50; "Your Reference"; Text[100]) { Caption = 'Votre référence'; }
        field(51; "External Document No."; Code[35]) { Caption = 'N° document externe'; }
        field(52; "Amount Excl. VAT"; Decimal) { Caption = 'Montant HT'; }
        field(53; "Amount Incl. VAT"; Decimal) { Caption = 'Montant TTC'; }
        field(54; "Operation Code"; Code[20]) { Caption = 'Code opération'; }
        field(55; "Sub-Operation Code"; Code[20]) { Caption = 'Code sous-opération'; }
        field(56; "Location Code"; Code[20]) { Caption = 'Code magasin'; }
        field(57; "Invoice No."; Code[20]) { Caption = 'N° facture'; }
        field(58; "Customer Price Group"; Code[20]) { Caption = 'Groupe prix client'; }
        field(59; "Salesperson Code"; Code[20]) { Caption = 'Code vendeur'; }
        field(60; "Transport Method Code"; Code[20]) { Caption = 'Code mode de transport'; }
    }

    keys
    {
        key(PK; "Entry No.") { Clustered = true; }
    }
}
