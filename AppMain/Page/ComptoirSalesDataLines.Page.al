page 83802 "bri_ComptoirSalesDataLines"
{
    Caption = 'Lignes';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "bri_ComptoirSalesDocLine";
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Lines)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field(Type; Rec.Type) { ApplicationArea = All; }
                field("No."; Rec."No.") { ApplicationArea = All; }
                field(Description; Rec.Description) { ApplicationArea = All; }
                field("Location Code"; Rec."Location Code") { ApplicationArea = All; }
                field("Bin Code"; Rec."Bin Code") { ApplicationArea = All; Visible = false; }
                field(Quantity; Rec.Quantity) { ApplicationArea = All; }
                field("Free Quantity"; Rec."Free Quantity") { ApplicationArea = All; }
                field("Free Nature Code"; Rec."Free Nature Code") { ApplicationArea = All; }
                field("Unit Price"; Rec."Unit Price") { ApplicationArea = All; }
                field("Qty. Shipped"; Rec."Qty. Shipped") { ApplicationArea = All; Visible = false; }
                field("Qty. Invoiced"; Rec."Qty. Invoiced") { ApplicationArea = All; Visible = false; }
                field("Operation Code"; Rec."Operation Code") { ApplicationArea = All; Visible = false; }
                field("Sub-Operation Code"; Rec."Sub-Operation Code") { ApplicationArea = All; Visible = false; }
                field("Your Reference"; Rec."Your Reference") { ApplicationArea = All; Visible = false; }
                field("Lot No."; Rec."Lot No.") { ApplicationArea = All; Visible = false; }
                field("Serial No."; Rec."Serial No.") { ApplicationArea = All; Visible = false; }
            }
        }
    }

    procedure SetData(var TempLine: Record "bri_ComptoirSalesDocLine" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        if TempLine.FindSet() then
            repeat
                Rec := TempLine;
                Rec.Insert();
            until TempLine.Next() = 0;
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;
}
