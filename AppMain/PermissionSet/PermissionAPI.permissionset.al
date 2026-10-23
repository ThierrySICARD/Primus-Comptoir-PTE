permissionset 83800 bri_PermComptoir
{
    Assignable = true;
    Permissions =
        codeunit "Environment information" = X,
        tabledata "bri_ComptoirSalesData" = RIMD,
        codeunit "bri_ComptoirSalesDataMgt" = X,
        page "bri_ComptoirSalesDataLines" = X,
        page "bri_ComptoirSalesDataComments" = X;
}