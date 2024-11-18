pageextension 50701 "Sales Receivable Setup" extends "Sales & Receivables Setup"
{
    layout
    {
        addafter("Customer Nos.")
        {
            field("Interemediate Cust No. Series"; Rec."Interemediate Cust No. Series")
            {
                ApplicationArea = All;
            }
        }
    }
}