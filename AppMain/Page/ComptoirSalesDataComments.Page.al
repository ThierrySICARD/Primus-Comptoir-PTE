page 83803 "bri_ComptoirSalesDataComments"
{
    Caption = 'Commentaires';
    PageType = ListPart;
    ApplicationArea = All;
    SourceTable = "bri_ComptoirSalesDocComment";
    SourceTableTemporary = true;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(Content)
        {
            repeater(Comments)
            {
                field("Line No."; Rec."Line No.") { ApplicationArea = All; }
                field(Rank; Rec.Rank) { ApplicationArea = All; }
                field(Location; Rec.Location) { ApplicationArea = All; }
                field(Comment; Rec.Comment) { ApplicationArea = All; }
                field(Preparation; Rec.Preparation) { ApplicationArea = All; }
                field(Transport; Rec.Transport) { ApplicationArea = All; }
                field(Invoicing; Rec.Invoicing) { ApplicationArea = All; }
                field("Production Order"; Rec."Production Order") { ApplicationArea = All; }
                field("Exclude From Invoice"; Rec."Exclude From Invoice") { ApplicationArea = All; }
            }
        }
    }

    procedure SetData(var TempComment: Record "bri_ComptoirSalesDocComment" temporary)
    begin
        Rec.Reset();
        Rec.DeleteAll();
        if TempComment.FindSet() then
            repeat
                Rec := TempComment;
                Rec.Insert();
            until TempComment.Next() = 0;
        if Rec.FindFirst() then;
        CurrPage.Update(false);
    end;
}
