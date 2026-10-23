codeunit 83802 bri_ComptoirStagingAPIProcess
{
    TableNo = bri_ComptoirSalesData;

    trigger OnRun()
    var
        TempHeader: Record "bri_ComptoirSalesDocHeader" temporary;
        TempLine: Record "bri_ComptoirSalesDocLine" temporary;
        TempComment: Record "bri_ComptoirSalesDocComment" temporary;
        SalesHeader: Record "Sales Header";
        DataMgt: Codeunit "bri_ComptoirSalesDataMgt";
        RawJson: Text;
    begin
        if Rec.Status = Rec.Status::Processed then
            Error('L''entrée %1 a déjà été traitée (document %2).', Rec."Entry No.", Rec."Document No.");

        RawJson := Rec.GetRawJson();
        DataMgt.ValidatePayload(RawJson);
        DataMgt.ParseDocument(RawJson, TempHeader, TempLine, TempComment);
        if not TempHeader.FindFirst() then
            Error(' Le contenu JSON n''a pas pu être analysé.');

        CreateSalesHeader(TempHeader, SalesHeader);
        CreateSalesLines(TempLine, SalesHeader);
        CreateSalesComments(TempComment, SalesHeader);

        Rec."Document Type" := CopyStr(Format(SalesHeader."Document Type"), 1, MaxStrLen(Rec."Document Type"));
        Rec."Document No." := SalesHeader."No.";
        Rec.Status := Rec.Status::Processed;
        Rec."Error Message" := '';
        Rec."Processed DateTime" := CurrentDateTime();
        Rec.Modify();
    end;

    local procedure CreateSalesHeader(TempHeader: Record "bri_ComptoirSalesDocHeader" temporary; var SalesHeader: Record "Sales Header")
    var
        ShippingTime: DateFormula;
        DocTypeText: Text;
    begin
        SalesHeader.Init();

        // INSERTION ENTETE Sales Header
        DocTypeText := TempHeader."Document Type";
        if DocTypeText = '' then
            DocTypeText := 'Order';
        if not Evaluate(SalesHeader."Document Type", DocTypeText) then
            Error('Document Type "%1" inconnu.', DocTypeText);

        SalesHeader.InitInsert();
        SalesHeader."No." := TempHeader."No.";

        // --------
        SalesHeader."bri_Type ordre" := TempHeader."Order Type";
        // --------

        if SalesHeader."No." <> '' then
            if SalesHeader.Get(SalesHeader."Document Type", SalesHeader."No.") then
                Error('Le document de vente %1 %2 existe déjà.', SalesHeader."Document Type", SalesHeader."No.");

        SalesHeader.Insert(true);

        // AJOUT DES INFORMATIONS COMMANDE
        if TempHeader."Sell-to Customer No." = '' then
            Error('Le champ "Sell-to Customer No." est obligatoire.');
        SalesHeader.Validate("Sell-to Customer No.", TempHeader."Sell-to Customer No.");

        if (TempHeader."Bill-to Customer No." <> '') and (TempHeader."Bill-to Customer No." <> SalesHeader."Bill-to Customer No.") then
            SalesHeader.Validate("Bill-to Customer No.", TempHeader."Bill-to Customer No.");
        if TempHeader."Ship-to Code" <> '' then
            SalesHeader.Validate("Ship-to Code", TempHeader."Ship-to Code");

        if TempHeader."Order Type" <> '' then
            SalesHeader.Validate("bri_Type ordre", TempHeader."Order Type");
        if TempHeader.Team <> '' then
            SalesHeader.Validate("bri_Equipe Agent", TempHeader.Team);
        if TempHeader."Operation Code" <> '' then
            SalesHeader.Validate("bri_Code Operation", TempHeader."Operation Code");
        if TempHeader."Sub-Operation Code" <> '' then
            SalesHeader.Validate("bri_Code Sous Operation", TempHeader."Sub-Operation Code");
        if TempHeader.Deposit <> 0 then
            SalesHeader.Validate(bri_Acompte, TempHeader.Deposit);

        if TempHeader."Creation Date" <> 0D then begin
            SalesHeader.Validate("Order Date", TempHeader."Creation Date");
            SalesHeader.Validate("Document Date", TempHeader."Creation Date");
        end;

        if TempHeader."Sell-to Customer Name" <> '' then
            SalesHeader."Sell-to Customer Name" := TempHeader."Sell-to Customer Name";
        if TempHeader."Sell-to Address" <> '' then
            SalesHeader."Sell-to Address" := TempHeader."Sell-to Address";
        if TempHeader."Sell-to Address 2" <> '' then
            SalesHeader."Sell-to Address 2" := TempHeader."Sell-to Address 2";
        if TempHeader."Sell-to City" <> '' then
            SalesHeader."Sell-to City" := TempHeader."Sell-to City";
        if TempHeader."Sell-to Post Code" <> '' then
            SalesHeader."Sell-to Post Code" := TempHeader."Sell-to Post Code";
        if TempHeader."Sell-to Country/Region Code" <> '' then
            SalesHeader."Sell-to Country/Region Code" := TempHeader."Sell-to Country/Region Code";

        if TempHeader."Bill-to Name" <> '' then
            SalesHeader."Bill-to Name" := TempHeader."Bill-to Name";
        if TempHeader."Bill-to Address" <> '' then
            SalesHeader."Bill-to Address" := TempHeader."Bill-to Address";
        if TempHeader."Bill-to Address 2" <> '' then
            SalesHeader."Bill-to Address 2" := TempHeader."Bill-to Address 2";
        if TempHeader."Bill-to City" <> '' then
            SalesHeader."Bill-to City" := TempHeader."Bill-to City";
        if TempHeader."Bill-to Post Code" <> '' then
            SalesHeader."Bill-to Post Code" := TempHeader."Bill-to Post Code";
        if TempHeader."Bill-to Country/Region Code" <> '' then
            SalesHeader."Bill-to Country/Region Code" := TempHeader."Bill-to Country/Region Code";

        if TempHeader."Ship-to Name" <> '' then
            SalesHeader."Ship-to Name" := TempHeader."Ship-to Name";
        if TempHeader."Ship-to Address" <> '' then
            SalesHeader."Ship-to Address" := TempHeader."Ship-to Address";
        if TempHeader."Ship-to Address 2" <> '' then
            SalesHeader."Ship-to Address 2" := TempHeader."Ship-to Address 2";
        if TempHeader."Ship-to City" <> '' then
            SalesHeader."Ship-to City" := TempHeader."Ship-to City";
        if TempHeader."Ship-to Post Code" <> '' then
            SalesHeader."Ship-to Post Code" := TempHeader."Ship-to Post Code";
        if TempHeader."Ship-to Country/Region Code" <> '' then
            SalesHeader."Ship-to Country/Region Code" := TempHeader."Ship-to Country/Region Code";

        if TempHeader."Payment Method Code" <> '' then
            SalesHeader.Validate("Payment Method Code", TempHeader."Payment Method Code");
        if TempHeader."Payment Terms Code" <> '' then
            SalesHeader.Validate("Payment Terms Code", TempHeader."Payment Terms Code");
        SalesHeader.Validate("Prices Including VAT", TempHeader."Prices Including VAT");
        if TempHeader."Shipment Method Code" <> '' then
            SalesHeader.Validate("Shipment Method Code", TempHeader."Shipment Method Code");
        if TempHeader."Shipping Agent Code" <> '' then
            SalesHeader.Validate("Shipping Agent Code", TempHeader."Shipping Agent Code");
        if TempHeader."Shipping Time" <> '' then begin
            if not Evaluate(ShippingTime, TempHeader."Shipping Time") then
                Error('Invalid shippingTime "%1".', TempHeader."Shipping Time");
            SalesHeader.Validate("Shipping Time", ShippingTime);
        end;
        if TempHeader."Requested Delivery Date" <> 0D then
            SalesHeader.Validate("Requested Delivery Date", TempHeader."Requested Delivery Date");
        if TempHeader."Promised Delivery Date" <> 0D then
            SalesHeader.Validate("Promised Delivery Date", TempHeader."Promised Delivery Date");
        if TempHeader."Delivery Time" <> 0T then
            SalesHeader.Validate("bri_Delivery Time", TempHeader."Delivery Time");
        if TempHeader."Transport Method Code" <> '' then
            SalesHeader.Validate("Transport Method", TempHeader."Transport Method Code");

        if TempHeader."Your Reference" <> '' then
            SalesHeader.Validate("Your Reference", TempHeader."Your Reference");
        if TempHeader."External Document No." <> '' then
            SalesHeader.Validate("External Document No.", TempHeader."External Document No.");
        if TempHeader."Location Code" <> '' then
            SalesHeader.Validate("Location Code", TempHeader."Location Code");
        if TempHeader."Customer Price Group" <> '' then
            SalesHeader.Validate("Customer Price Group", TempHeader."Customer Price Group");
        if TempHeader."Salesperson Code" <> '' then
            SalesHeader.Validate("Salesperson Code", TempHeader."Salesperson Code");

        SalesHeader.Modify(true);
    end;

    local procedure CreateSalesLines(var TempLine: Record "bri_ComptoirSalesDocLine" temporary; SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesLineMgt: Codeunit "bri_Sales Line";
        LineNo: Integer;
        TypeText: Text;
    begin
        TempLine.Reset();
        if TempLine.FindSet() then
            repeat
                LineNo := TempLine."Line No.";
                if LineNo = 0 then
                    LineNo := NextLineNo(SalesHeader);

                SalesLine.Init();
                SalesLine."Document Type" := SalesHeader."Document Type";
                SalesLine."Document No." := SalesHeader."No.";
                SalesLine."Line No." := LineNo;
                SalesLine.Insert(true);

                TypeText := TempLine.Type;
                if TypeText = '' then
                    TypeText := 'Item';
                if not Evaluate(SalesLine.Type, TypeText) then
                    Error('Line %1: unknown type "%2".', TempLine."Seq. No.", TypeText);
                SalesLine.Validate(Type, SalesLine.Type);

                SalesLine.Validate("No.", TempLine."No.");
                if TempLine."Location Code" <> '' then
                    SalesLine.Validate("Location Code", TempLine."Location Code");
                if TempLine."Your Reference" <> '' then
                    SalesLine.Validate("bri_Your Reference", TempLine."Your Reference");
                SalesLine.Validate(Quantity, TempLine.Quantity);
                if TempLine."Unit Price" <> 0 then
                    SalesLine.Validate("Unit Price", TempLine."Unit Price");
                if TempLine."Free Nature Code" <> '' then
                    SalesLine.Validate("bri_Nature gratuite", TempLine."Free Nature Code");
                if TempLine."Free Quantity" <> 0 then
                    SalesLine.Validate("bri_Quantite gratuite", TempLine."Free Quantity");
                if TempLine."Bin Code" <> '' then
                    SalesLine.Validate("Bin Code", TempLine."Bin Code");

                SalesLineMgt.ChargePosteStockTypeordre(SalesLine);

                if TempLine."Operation Code" <> '' then
                    SalesLine.Validate("bri_Code Operation", TempLine."Operation Code")
                else
                    if SalesHeader."bri_Code Operation" <> '' then
                        SalesLine.Validate("bri_Code Operation", SalesHeader."bri_Code Operation");
                if TempLine."Sub-Operation Code" <> '' then
                    SalesLine.Validate("bri_Code Sous Operation", TempLine."Sub-Operation Code")
                else
                    if SalesHeader."bri_Code Sous Operation" <> '' then
                        SalesLine.Validate("bri_Code Sous Operation", SalesHeader."bri_Code Sous Operation");

                SalesLine.Modify(true);
            until TempLine.Next() = 0;
    end;

    local procedure CreateSalesComments(var TempComment: Record "bri_ComptoirSalesDocComment" temporary; SalesHeader: Record "Sales Header")
    var
        SalesCommentLine: Record "Sales Comment Line";
        NextCommentLineNo: Integer;
        Pos: Integer;
        Chunk: Text;
    begin
        TempComment.Reset();
        if TempComment.FindSet() then
            repeat
                Pos := 1;
                while Pos <= StrLen(TempComment.Comment) do begin
                    Chunk := CopyStr(TempComment.Comment, Pos, MaxStrLen(SalesCommentLine.Comment));
                    NextCommentLineNo += 10000;

                    SalesCommentLine.Init();
                    SalesCommentLine."Document Type" := "Sales Comment Document Type".FromInteger(SalesHeader."Document Type".AsInteger());
                    SalesCommentLine."No." := SalesHeader."No.";
                    SalesCommentLine."Document Line No." := TempComment."Line No.";
                    SalesCommentLine."Line No." := NextCommentLineNo;
                    SalesCommentLine.Date := WorkDate();
                    SalesCommentLine.Comment := CopyStr(Chunk, 1, MaxStrLen(SalesCommentLine.Comment));
                    SalesCommentLine.Insert(true);

                    Pos += MaxStrLen(SalesCommentLine.Comment);
                end;
            until TempComment.Next() = 0;
    end;

    local procedure NextLineNo(SalesHeader: Record "Sales Header"): Integer
    var
        SalesLine: Record "Sales Line";
    begin
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindLast() then
            exit(SalesLine."Line No." + 10000);
        exit(10000);
    end;
}
