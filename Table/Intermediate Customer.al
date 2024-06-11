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
            DataClassification = ToBeClassified;
        }
        field(2; Name; Text[100])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "Approval Status"; enum IntermediateCustomerStatus)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; No)
        {
            Clustered = true;
        }
    }
}