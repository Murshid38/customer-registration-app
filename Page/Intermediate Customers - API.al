page 50703 "Intermediate Customers - API"
{
    PageType = API;
    EntityCaption = 'Intermediate Customer';
    EntitySetCaption = 'Intermediate Customers';
    EntityName = 'intermediateCustomer';
    EntitySetName = 'intermediateCustomers';
    APIPublisher = 'dev';
    APIGroup = 'trialBC';
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
                field(systemId; Rec.SystemId) { }
                field(no; Rec.No) { }
                field(name; Rec.Name) { }
                field(address; Rec.Address) { }
                field(city; Rec.City) { }
                field(phoneNo; Rec.PhoneNo) { }
                field(approvalStatus; Rec."Approval Status")
                {
                    Editable = false;
                }
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
    procedure CancelApprovalRequest(var ActionContext: WebServiceActionContext)
    begin
        IntermediateCustomerHandler.CancelApprovalRequest(ActionContext, Rec);
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