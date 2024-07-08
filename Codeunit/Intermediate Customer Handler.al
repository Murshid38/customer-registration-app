codeunit 50101 "Intermediate Customer Handler"
{
    internal procedure ConvertToCustomer(var ActionContext: WebServiceActionContext; Rec: Record "Intermediate Customer")
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        if not IntermediateCustomer.GetBySystemId(Rec.SystemId) then
            Error(CannotFindIntCustomerErr, Rec.SystemId);

        Rec.ConvertToCustomer();

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Intermediate Customers - API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Created);
    end;

    internal procedure SendApprovalRequest(var ActionContext: WebServiceActionContext; Rec: Record "Intermediate Customer")
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        if not IntermediateCustomer.GetBySystemId(Rec.SystemId) then
            Error(CannotFindIntCustomerErr, Rec.SystemId);

        IntermediateCustomer."Approval Status" := IntermediateCustomer."Approval Status"::"Pending Approval";
        IntermediateCustomer.Modify(false);

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Intermediate Customers - API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    var
        CannotFindIntCustomerErr: Label 'Intermediate Customer with ID %1 cannot be found.', Comment = '%1 - the System ID of the Intermediate Customer';
}