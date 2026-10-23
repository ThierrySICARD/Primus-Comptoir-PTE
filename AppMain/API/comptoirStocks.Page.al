page 83805 comptoirStocks
{
    APIGroup = 'comptoir';
    APIPublisher = 'PrimusAPI';
    APIVersion = 'v2.0';
    Caption = 'stock';
    DelayedInsert = true;
    DeleteAllowed = false;
    EntityCaption = 'stock';
    EntityName = 'comptoirStock';
    EntitySetCaption = 'stock';
    EntitySetName = 'comptoirStocks';
    Extensible = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = API;
    SourceTable = Item;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(company; CompanyName) { }
                field(no; Rec."No.") { }
                field(stockPhysique; Rec."bri_Inventory By Date") { }
                field(disponible; Rec.bri_Disponible) { }
                field(disponible2; Rec."bri_Dispo 2") { }
                field(locationFilter; Rec."Location Filter") { }
            }
            // part(stockByLocation; bri_stockByLocation)
            // {
            //     SubPageLink = "bri_Item No." = field("No."), bri_LocationFilter = field("Location Filter");
            // }
            // part(stockDetails; bri_stockDetails)
            // {
            //     SubPageLink = "No." = field("No.");
            // }
            // part(stockDetailsByLocation; bri_reservationEntry)
            // {
            //     SubPageLink = "Item No." = field("No.");
            // }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        Rec."Location Filter" := Rec.GetFilter("Location Filter");

        // Rec.bri_Disponible := C_CalculStock.CalculDisponible(Rec);
    end;

    // var
    //     C_CalculStock: Codeunit "bri_Calcul Stocks";
}
