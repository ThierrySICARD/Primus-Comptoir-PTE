page 83804 "bri_ComptoirSalesDataCard"
{
    Caption = 'Données de vente Comptoir';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = None;
    SourceTable = "bri_ComptoirSalesData";
    InsertAllowed = false;

    layout
    {
        area(Content)
        {
            group(Integration)
            {
                Caption = 'Intégration';

                field("Entry No."; Rec."Entry No.") { ApplicationArea = All; Editable = false; }
                field("Point Of Sale"; Rec."Point Of Sale") { ApplicationArea = All; Editable = false; }
                field("Received At"; Rec."Received At") { ApplicationArea = All; Editable = false; }
                field(Status; Rec.Status) { ApplicationArea = All; }
                field("Error Message"; Rec."Error Message") { ApplicationArea = All; }
                field("Document No."; Rec."Document No.") { ApplicationArea = All; Editable = false; }
                field("Processed DateTime"; Rec."Processed DateTime") { ApplicationArea = All; Editable = false; }
            }
            group(General)
            {
                Caption = 'Général';
                Editable = false;

                field("Document Type"; SalesHeader."Document Type") { ApplicationArea = All; }
                field("No."; SalesHeader."No.") { ApplicationArea = All; }
                field("Creation Date"; SalesHeader."Creation Date") { ApplicationArea = All; }
                field("Order Type"; SalesHeader."Order Type") { ApplicationArea = All; }
                field(Team; SalesHeader.Team) { ApplicationArea = All; }
                field("External Document No."; SalesHeader."External Document No.") { ApplicationArea = All; }
                field("Your Reference"; SalesHeader."Your Reference") { ApplicationArea = All; }
                field("Invoice No."; SalesHeader."Invoice No.") { ApplicationArea = All; }
                field("Location Code"; SalesHeader."Location Code") { ApplicationArea = All; }
                field("Customer Price Group"; SalesHeader."Customer Price Group") { ApplicationArea = All; }
                field("Salesperson Code"; SalesHeader."Salesperson Code") { ApplicationArea = All; }
            }
            part(Lines; "bri_ComptoirSalesDataLines")
            {
                ApplicationArea = All;
                Caption = 'Lignes';
            }
            part(Comments; "bri_ComptoirSalesDataComments")
            {
                ApplicationArea = All;
                Caption = 'Commentaires';
            }
            group(SellTo)
            {
                Caption = 'Donneur d''ordre';
                Editable = false;

                field("Sell-to Customer No."; SalesHeader."Sell-to Customer No.") { ApplicationArea = All; }
                field("Sell-to Customer Name"; SalesHeader."Sell-to Customer Name") { ApplicationArea = All; }
                field("Sell-to Address"; SalesHeader."Sell-to Address") { ApplicationArea = All; }
                field("Sell-to Address 2"; SalesHeader."Sell-to Address 2") { ApplicationArea = All; }
                field("Sell-to Post Code"; SalesHeader."Sell-to Post Code") { ApplicationArea = All; }
                field("Sell-to City"; SalesHeader."Sell-to City") { ApplicationArea = All; }
                field("Sell-to Country/Region Code"; SalesHeader."Sell-to Country/Region Code") { ApplicationArea = All; }
            }
            group(BillTo)
            {
                Caption = 'Facturation';
                Editable = false;

                field("Bill-to Customer No."; SalesHeader."Bill-to Customer No.") { ApplicationArea = All; }
                field("Bill-to Name"; SalesHeader."Bill-to Name") { ApplicationArea = All; }
                field("Bill-to Address"; SalesHeader."Bill-to Address") { ApplicationArea = All; }
                field("Bill-to Address 2"; SalesHeader."Bill-to Address 2") { ApplicationArea = All; }
                field("Bill-to Post Code"; SalesHeader."Bill-to Post Code") { ApplicationArea = All; }
                field("Bill-to City"; SalesHeader."Bill-to City") { ApplicationArea = All; }
                field("Bill-to Country/Region Code"; SalesHeader."Bill-to Country/Region Code") { ApplicationArea = All; }
            }
            group(ShipTo)
            {
                Caption = 'Livraison';
                Editable = false;

                field("Ship-to Code"; SalesHeader."Ship-to Code") { ApplicationArea = All; }
                field("Ship-to Name"; SalesHeader."Ship-to Name") { ApplicationArea = All; }
                field("Ship-to Address"; SalesHeader."Ship-to Address") { ApplicationArea = All; }
                field("Ship-to Address 2"; SalesHeader."Ship-to Address 2") { ApplicationArea = All; }
                field("Ship-to Post Code"; SalesHeader."Ship-to Post Code") { ApplicationArea = All; }
                field("Ship-to City"; SalesHeader."Ship-to City") { ApplicationArea = All; }
                field("Ship-to Country/Region Code"; SalesHeader."Ship-to Country/Region Code") { ApplicationArea = All; }
            }
            group(PaymentShipping)
            {
                Caption = 'Paiement et expédition';
                Editable = false;

                field("Payment Method Code"; SalesHeader."Payment Method Code") { ApplicationArea = All; }
                field("Payment Terms Code"; SalesHeader."Payment Terms Code") { ApplicationArea = All; }
                field("Prices Including VAT"; SalesHeader."Prices Including VAT") { ApplicationArea = All; }
                field("Shipment Method Code"; SalesHeader."Shipment Method Code") { ApplicationArea = All; }
                field("Shipping Agent Code"; SalesHeader."Shipping Agent Code") { ApplicationArea = All; }
                field("Shipping Time"; SalesHeader."Shipping Time") { ApplicationArea = All; }
                field("Transport Method Code"; SalesHeader."Transport Method Code") { ApplicationArea = All; }
                field("Requested Delivery Date"; SalesHeader."Requested Delivery Date") { ApplicationArea = All; }
                field("Promised Delivery Date"; SalesHeader."Promised Delivery Date") { ApplicationArea = All; }
                field("Delivery Time"; SalesHeader."Delivery Time") { ApplicationArea = All; }
            }
            group(Amounts)
            {
                Caption = 'Montants';
                Editable = false;

                field("Amount Excl. VAT"; SalesHeader."Amount Excl. VAT") { ApplicationArea = All; }
                field("Amount Incl. VAT"; SalesHeader."Amount Incl. VAT") { ApplicationArea = All; }
                field(Deposit; SalesHeader.Deposit) { ApplicationArea = All; }
                field("Operation Code"; SalesHeader."Operation Code") { ApplicationArea = All; }
                field("Sub-Operation Code"; SalesHeader."Sub-Operation Code") { ApplicationArea = All; }
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
        SalesHeader: Record "bri_ComptoirSalesDocHeader" temporary;
        TempSalesLine: Record "bri_ComptoirSalesDocLine" temporary;
        TempSalesComment: Record "bri_ComptoirSalesDocComment" temporary;
        DataMgt: Codeunit "bri_ComptoirSalesDataMgt";
        ImportMgt: Codeunit "bri_ComptoirStagingAPIJob";

    trigger OnAfterGetRecord()
    begin
        DataMgt.ParseDocument(Rec.GetRawJson(), SalesHeader, TempSalesLine, TempSalesComment);
        CurrPage.Lines.Page.SetData(TempSalesLine);
        CurrPage.Comments.Page.SetData(TempSalesComment);
    end;
}
