page 50102 "APIV2 - Intermediate Customers"
{
    PageType = API;
    EntityCaption = 'Intermediate Customer';
    EntitySetCaption = 'Intermediate Customers';
    EntityName = 'intermediateCustomer';
    EntitySetName = 'intermediateCustomers';
    APIPublisher = 'Dev';
    APIGroup = 'TrialBC';
    APIVersion = 'v2.0';
    SourceTable = "Intermediate Customer";
    DelayedInsert = true;
    ODataKeyFields = SystemId;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(SystemId; Rec.SystemId)
                {
                    Caption = 'No';
                }
                field(No; Rec.No)
                {
                    Caption = 'No';
                }
                field(Name; Rec.Name)
                {
                    Caption = 'Name';
                }
                field(approvalStatus; Rec."Approval Status")
                {
                    Caption = 'Approval Status';
                }
            }
        }
    }
}