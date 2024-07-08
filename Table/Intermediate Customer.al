table 50100 "Intermediate Customer"
{
    Caption = 'Intermediate Customer';
    DataClassification = ToBeClassified;
    LookupPageId = "Intermediate Customer List";
    DrillDownPageId = "Intermediate Customer Card";
    DataCaptionFields = No, Name;

    fields
    {
        field(1; No; Code[20])
        {
            Caption = 'No';
            ToolTip = 'Specifies the number of the Intermediate Customer.';
            NotBlank = true;
        }
        field(2; Name; Text[100])
        {
            Caption = 'Name';
            ToolTip = 'Specifies the name of the Intermediate Customer.';
        }
        field(3; "Approval Status"; enum "Intermediate Customer Status")
        {
            Caption = 'Approval Status';
            ToolTip = 'Specifies the approval status of the Intermediate Customer.';
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }

    procedure SetNoFromNoSeries()
    var
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        IntermediateCustomer: Record "Intermediate Customer";
        NoSeries: Codeunit "No. Series";
        TempIntCustNo: Code[20];
    begin
        SalesReceivablesSetup.Get();
        SalesReceivablesSetup.TestField("Interemediate Cust No. Series");
        TempIntCustNo := NoSeries.GetLastNoUsed(SalesReceivablesSetup."Interemediate Cust No. Series");

        if not IntermediateCustomer.Get(TempIntCustNo) then
            Rec.No := TempIntCustNo
        else
            Rec.No := NoSeries.GetNextNo(SalesReceivablesSetup."Interemediate Cust No. Series");
    end;

    internal procedure ConvertToCustomer()
    var
        Customer: Record Customer;
        SalesReceivablesSetup: Record "Sales & Receivables Setup";
        NoSeries: Codeunit "No. Series";
    begin
        if Rec."Approval Status" <> Rec."Approval Status"::Released then
            Error(IntCustomerNotApprovedErr, Rec.No);

        SalesReceivablesSetup.Get();

        Customer.Init();
        SalesReceivablesSetup.TestField("Customer Nos.");
        Customer."No." := NoSeries.GetNextNo(SalesReceivablesSetup."Customer Nos.");
        Customer.Name := Rec.Name + ' Changed Code';
        if not Customer.Insert(true) then
            Error(CannotCreateCustomerErr, Rec.No);
    end;

    trigger OnInsert()
    begin
        SetNoFromNoSeries();
    end;

    var
        IntCustomerNotApprovedErr: Label 'The Intermediate Customer %1 must be approved before it can be converted to a Customer.', Comment = '%1 - the No of the Intermediate Customer';
        CannotCreateCustomerErr: Label 'Failed to convert Intermediate Customer %1 to Customer.', Comment = '%1 - the No of the Intermediate Customer';
}