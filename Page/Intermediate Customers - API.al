page 50102 "Intermediate Customers - API"
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
    Editable = false;
    DataAccessIntent = ReadOnly;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(systemId; Rec.SystemId) { }
                field(no; Rec.No) { }
                field(name; Rec.Name) { }
                field(approvalStatus; Rec."Approval Status") { }
            }
        }
    }

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure SendApprovalRequest(var ActionContext: WebServiceActionContext)
    begin
        IntermediateCustomerHandler.SendApprovalRequest(ActionContext, Rec);
    end;

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure ConvertToCustomer(var ActionContext: WebServiceActionContext)
    begin
        IntermediateCustomerHandler.ConvertToCustomer(ActionContext, Rec);
    end;

    var
        IntermediateCustomerHandler: Codeunit "Intermediate Customer Handler";
}