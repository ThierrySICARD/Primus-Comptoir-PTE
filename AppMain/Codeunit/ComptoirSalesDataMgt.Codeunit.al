codeunit 83800 "bri_ComptoirSalesDataMgt"
{
    procedure ValidatePayload(RawJson: Text)
    var
        JObj: JsonObject;
        JTok: JsonToken;
        JLineTok: JsonToken;
        JArr: JsonArray;
        Errors: List of [Text];
        ErrorText: Text;
        Msg: Text;
        i: Integer;
    begin
        if RawJson = '' then
            Error('The "rawJson" property is required: send {"rawJson": "<order JSON as an escaped string>"}. Properties placed at the root of the body are ignored.');

        if not JObj.ReadFrom(RawJson) then
            Error('The "rawJson" property is not valid JSON, or is not a JSON object.');

        if GetTextValue(JObj, 'externalDocumentNo') = '' then
            Errors.Add('"externalDocumentNo" is missing or empty');
        if GetTextValue(JObj, 'documentType') = '' then
            Errors.Add('"documentType" is missing or empty');

        if not JObj.Get('salesLine', JTok) then
            Errors.Add('"salesLine" is missing')
        else
            if not JTok.IsArray() then
                Errors.Add('"salesLine" must be an array')
            else begin
                JArr := JTok.AsArray();
                if JArr.Count() = 0 then
                    Errors.Add('"salesLine" must contain at least one line');
                for i := 0 to JArr.Count() - 1 do begin
                    JArr.Get(i, JLineTok);
                    if not JLineTok.IsObject() then
                        Errors.Add(StrSubstNo('salesLine[%1] must be an object', i))
                    else begin
                        if GetTextValue(JLineTok.AsObject(), 'no') = '' then
                            Errors.Add(StrSubstNo('salesLine[%1]: "no" is missing or empty', i));
                        if not (JLineTok.AsObject().Get('quantity', JTok) and JTok.IsValue() and not JTok.AsValue().IsNull()) then
                            Errors.Add(StrSubstNo('salesLine[%1]: "quantity" is missing', i));
                    end;
                end;
            end;

        if Errors.Count() > 0 then begin
            foreach Msg in Errors do begin
                if ErrorText <> '' then
                    ErrorText += ' | ';
                ErrorText += Msg;
            end;
            Error('Invalid order payload: %1', ErrorText);
        end;
    end;

    local procedure GetTextValue(JObj: JsonObject; JKey: Text): Text
    var
        JTok: JsonToken;
    begin
        if not JObj.Get(JKey, JTok) then
            exit('');
        if not JTok.IsValue() then
            exit('');
        if JTok.AsValue().IsNull() then
            exit('');
        exit(JTok.AsValue().AsText());
    end;

    procedure ParseDocument(RawJson: Text; var TempHeader: Record "bri_ComptoirSalesDocHeader" temporary; var TempLine: Record "bri_ComptoirSalesDocLine" temporary; var TempComment: Record "bri_ComptoirSalesDocComment" temporary)
    var
        Item: Record Item;
        JObj: JsonObject;
        JTok: JsonToken;
        JLineTok: JsonToken;
        JArr: JsonArray;
        RecRef: RecordRef;
        Seq: Integer;
    begin
        TempHeader.Reset();
        TempHeader.DeleteAll();
        TempLine.Reset();
        TempLine.DeleteAll();
        TempComment.Reset();
        TempComment.DeleteAll();

        if RawJson = '' then
            exit;
        if not JObj.ReadFrom(RawJson) then
            exit;

        TempHeader.Init();
        TempHeader."Entry No." := 1;
        RecRef.GetTable(TempHeader);
        FillFromJson(JObj, RecRef, HeaderFieldMap());
        RecRef.SetTable(TempHeader);
        TempHeader.Insert();

        if JObj.Get('salesLine', JTok) and JTok.IsArray() then begin
            JArr := JTok.AsArray();
            foreach JLineTok in JArr do
                if JLineTok.IsObject() then begin
                    Seq += 1;
                    TempLine.Init();
                    TempLine."Seq. No." := Seq;
                    RecRef.GetTable(TempLine);
                    FillFromJson(JLineTok.AsObject(), RecRef, LineFieldMap());
                    RecRef.SetTable(TempLine);
                    if (TempLine.Type = 'Item') and (TempLine."No." <> '') then
                        if Item.Get(TempLine."No.") then
                            TempLine.Description := Item.Description;
                    TempLine.Insert();
                end;
        end;

        Seq := 0;
        if JObj.Get('salesComments', JTok) and JTok.IsArray() then begin
            JArr := JTok.AsArray();
            foreach JLineTok in JArr do
                if JLineTok.IsObject() then begin
                    Seq += 1;
                    TempComment.Init();
                    TempComment."Seq. No." := Seq;
                    RecRef.GetTable(TempComment);
                    FillFromJson(JLineTok.AsObject(), RecRef, CommentFieldMap());
                    RecRef.SetTable(TempComment);
                    TempComment.Insert();
                end;
        end;
    end;

    local procedure FillFromJson(JObj: JsonObject; var RecRef: RecordRef; FieldMap: Dictionary of [Text, Integer])
    var
        JTok: JsonToken;
        FRef: FieldRef;
        JKey: Text;
    begin
        foreach JKey in FieldMap.Keys() do
            if JObj.Get(JKey, JTok) then
                if JTok.IsValue() then begin
                    FRef := RecRef.Field(FieldMap.Get(JKey));
                    SetFieldValue(FRef, JTok.AsValue());
                end;
    end;

    local procedure SetFieldValue(var FRef: FieldRef; JVal: JsonValue)
    var
        DateVal: Date;
        TimeVal: Time;
    begin
        if JVal.IsNull() then
            exit;

        case FRef.Type of
            FieldType::Text, FieldType::Code:
                FRef.Value := CopyStr(JVal.AsText(), 1, FRef.Length);
            FieldType::Decimal:
                FRef.Value := JVal.AsDecimal();
            FieldType::Integer:
                FRef.Value := JVal.AsInteger();
            FieldType::Boolean:
                FRef.Value := JVal.AsBoolean();
            FieldType::Date:
                if Evaluate(DateVal, JVal.AsText(), 9) then
                    FRef.Value := DateVal;
            FieldType::Time:
                if Evaluate(TimeVal, JVal.AsText(), 9) then
                    FRef.Value := TimeVal;
        end;
    end;

    local procedure HeaderFieldMap() Map: Dictionary of [Text, Integer]
    begin
        Map.Add('documentType', 2);
        Map.Add('no', 3);
        Map.Add('dateCreation', 4);
        Map.Add('typeOrdre', 5);
        Map.Add('equipeAgent', 6);
        Map.Add('sellToCustomerNo', 10);
        Map.Add('sellToCustomerName', 11);
        Map.Add('sellToAddress', 12);
        Map.Add('sellToAddress2', 13);
        Map.Add('sellToCity', 14);
        Map.Add('sellToPostCode', 15);
        Map.Add('sellToCountryRegion', 16);
        Map.Add('billToNo', 20);
        Map.Add('billToName', 21);
        Map.Add('billToAddress', 22);
        Map.Add('billToAddress2', 23);
        Map.Add('billToCity', 24);
        Map.Add('billToPostCode', 25);
        Map.Add('billToCountryRegion', 26);
        Map.Add('shipToNo', 30);
        Map.Add('shipToName', 31);
        Map.Add('shipToAddress', 32);
        Map.Add('shipToAddress2', 33);
        Map.Add('shipToCity', 34);
        Map.Add('shipToPostCode', 35);
        Map.Add('shipToCountryRegion', 36);
        Map.Add('paymentMethod', 40);
        Map.Add('paymentTerms', 41);
        Map.Add('pricesIncludingVAT', 42);
        Map.Add('shipmentMethod', 43);
        Map.Add('shippingAgent', 44);
        Map.Add('shippingTime', 45);
        Map.Add('requestedDeliveryDate', 46);
        Map.Add('promisedDeliveryDate', 47);
        Map.Add('PWS_deliveryTime', 48);
        Map.Add('acompte', 49);
        Map.Add('yourReference', 50);
        Map.Add('externalDocumentNo', 51);
        Map.Add('montantHT', 52);
        Map.Add('montantTTC', 53);
        Map.Add('codeOperation', 54);
        Map.Add('codeSousOperation', 55);
        Map.Add('locationCode', 56);
        Map.Add('invoiceNo', 57);
        Map.Add('customerPriceGroup', 58);
        Map.Add('salepersonPurchaser', 59);
        Map.Add('transportMethod', 60);
    end;

    local procedure CommentFieldMap() Map: Dictionary of [Text, Integer]
    begin
        Map.Add('lineNo', 2);
        Map.Add('rang', 3);
        Map.Add('emplacement', 4);
        Map.Add('text', 5);
        Map.Add('preparation', 6);
        Map.Add('transport', 7);
        Map.Add('facturation', 8);
        Map.Add('ordreFabrication', 9);
        Map.Add('exclureFacture', 10);
    end;

    local procedure LineFieldMap() Map: Dictionary of [Text, Integer]
    begin
        Map.Add('lineNo', 2);
        Map.Add('type', 3);
        Map.Add('no', 4);
        Map.Add('location', 6);
        Map.Add('binCode', 7);
        Map.Add('quantity', 8);
        Map.Add('qtyGratuite', 9);
        Map.Add('natureGratuite', 10);
        Map.Add('qtyShipped', 11);
        Map.Add('qtyInvoiced', 12);
        Map.Add('unitPrice', 13);
        Map.Add('codeOperation', 14);
        Map.Add('codeSousOperation', 15);
        Map.Add('yourReference', 16);
        Map.Add('lotNo', 17);
        Map.Add('serialNo', 18);
    end;
}
