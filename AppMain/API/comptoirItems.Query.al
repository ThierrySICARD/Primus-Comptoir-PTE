query 83800 bri_comptoirItems
{
    APIGroup = 'comptoir';
    APIPublisher = 'PrimusAPI';
    APIVersion = 'v2.0';
    Caption = 'comptoirItems';
    EntityName = 'comptoirItem';
    EntitySetName = 'comptoirItems';
    QueryType = API;

    elements
    {
        dataitem(CustomerPriceGroup; "Customer Price Group")
        {
            DataItemTableFilter = bri_Comptoir = const(true);

            column(customerPriceGroupCode; Code) { }

            dataitem(PriceListLine; "Price List Line")
            {
                DataItemLink = "Source No." = CustomerPriceGroup.Code;
                DataItemTableFilter = "Source Type" = const("Customer Price Group"), "Asset Type" = const(Item);
                SqlJoinType = InnerJoin;

                column(sourceType; "Source Type") { }
                column(PriceListLines; "Price List Code") { }

                dataitem(Item; Item)
                {
                    DataItemLink = "No." = PriceListLine."Asset No.";
                    SqlJoinType = InnerJoin;

                    column(no; "No.") { }
                    column(no2; "No. 2") { }
                    column(description; Description) { }
                    column(description2; "Description 2") { }
                    column(searchDescription; "Search Description") { }
                    column(millesime; bri_Millesime) { }
                    column(compteAge; "bri_Compte age") { }
                    column(degre; bri_Degre) { }
                    column(categorie; bri_Categorie) { }
                    column(appellation; bri_Appellation) { }
                    column(couleur; bri_Couleur) { }
                    column(regieArticle; "bri_Regie Article") { }
                    column(produitDeBase; "bri_Produit de base") { }
                    column(uniteConditionnementAppro; "bri_Unite Conditionnement App.") { }
                    column(baseUnitOfMeasure; "Base Unit of Measure") { }
                    column(classement; bri_Classement) { }
                    column(region; bri_Region) { }
                    column(nature; bri_Nature) { }
                    column(habillage; bri_Habillage) { }
                    column(certification; bri_Certification) { }
                    column(etatProduit; "bri_Etat produit") { }
                    column(medaille; bri_Medaille) { }
                    column(distinction1; bri_Distinction1) { }
                    column(distinction2; bri_Distinction2) { }
                    column(distinction3; bri_Distinction3) { }
                    column(distinction4; bri_Distinction4) { }
                    column(distinction5; bri_Distinction5) { }
                    column(axe1; "bri_Axe 1") { }
                    column(axe2; "bri_Axe 2") { }
                    column(axe3; "bri_Axe 3") { }
                    column(axe4; "bri_Axe 4") { }
                    column(axe5; "bri_Axe 5") { }
                    column(vatProdPostingGroup; "VAT Prod. Posting Group") { }
                    column(droitRegie; "bri_Droit regie") { }
                    column(vignette; bri_Vignette) { }
                    column(unitPrice; "Unit Price") { }
                    column(vendorCode; "Vendor No.") { }
                    column(budgetFamily; "bri_Item Budget Family") { }
                    column(netWeight; "Net Weight") { }
                    column(grossWeight; "Gross Weight") { }
                    column(blocked; Blocked) { }
                    column(baseGencod; "bri_Base Unit Gencod") { }
                    column(packGencod; "bri_Packaging Unit Gencod") { }
                    column(paletteGencode; "bri_Palette Gencod") { }
                    column(exclureStocketPlanning; "bri_Exclure Stock et Planning") { }
                    column(type; Type) { }
                    column(itemTrackingCode; "Item Tracking Code") { }


                    // column(articleInternet; "bri_Article Internet") { }
                    // column(countryRegionOfOriginCode; "Country/Region of Origin Code") { }
                    // column(certification2; "bri_Certification 2") { }
                    // column(certification3; "bri_Certification 3") { }
                    // column(certification4; "bri_Certification 4") { }
                    // column(certification5; "bri_Certification 5") { }
                    // column(standardCost; "Standard Cost") { }
                    // column(unitCost; "Unit Cost") { }
                    // column(prixDePlace; "bri_Prix de place") { }
                    // column(prixRevente; "bri_Prix de revente primeurs") { }
                    // column(prixRevient; "bri_Prix Revient Previsionnel") { }
                    // column(zoneViticole; "bri_Zone Viticole") { }
                    // column(customerNo; "bri_Customer No.") { }
                    // column(nomenclatureProduit; "Tariff No.") { }
                    // column(appellationRegie; "bri_Appellation regie") { }
                    // column(ancienNoArticle; "bri_Ancien No Article") { }
                    // column(uniteExpedition; "bri_Unite Expedition") { }
                    // column(systemModifiedAt; SystemModifiedAt) { }
                }
            }
        }
    }
}
