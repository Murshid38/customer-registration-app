tableextension 50100 "Sales Receivable Setup" extends "Sales & Receivables Setup"
{
    fields
    {
        field(50100; "Interemediate Cust No. Series"; Code[20])
        {
            Caption = 'Intermediate Cust Nos.';
            ToolTip = 'Specifies the number series for the intermediate customers.';
            TableRelation = "No. Series";
        }
    }
}