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

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {
                field(systemId; Rec.SystemId)
                {
                    Caption = 'System Id';
                }
                field(no; Rec.No)
                {
                    Caption = 'No';
                }
                field(name; Rec.Name)
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

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure SendApprovalRequest(var ActionContext: WebServiceActionContext)
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        if not IntermediateCustomer.GetBySystemId(Rec.SystemId) then
            Error(CannotFindIntCustomerErr, Rec.SystemId);

        if IntermediateCustomer."Approval Status" = IntermediateCustomer."Approval Status"::Open then begin
            IntermediateCustomer."Approval Status" := IntermediateCustomer."Approval Status"::"Pending Approval";
            IntermediateCustomer.Modify();
        end;

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Intermediate Customers - API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    [ServiceEnabled]
    [Scope('Cloud')]
    procedure CreateCustomer(var ActionContext: WebServiceActionContext)
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        IntermediateCustomer.Init();
        IntermediateCustomer.No := 'INTCUST0004';
        IntermediateCustomer.Name := 'Test 3';
        IntermediateCustomer."Approval Status" := IntermediateCustomer."Approval Status"::Open;
        IntermediateCustomer.Insert();

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Intermediate Customers - API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    var
        CannotFindIntCustomerErr: Label 'Intermediate Customer with ID %1 cannot be found.', Comment = '%1 - the System ID of the Intermediate Customer';
}