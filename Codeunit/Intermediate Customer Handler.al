codeunit 50702 "Intermediate Customer Handler"
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

        if ApprovalsMgmtSqBase.CheckIntCustomerApprovalsWorkflowEnable(Rec) then
            ApprovalsMgmtSqBase.OnSendIntCustomerForApproval(Rec);

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Intermediate Customers - API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    internal procedure CancelApprovalRequest(var ActionContext: WebServiceActionContext; Rec: Record "Intermediate Customer")
    var
        IntermediateCustomer: Record "Intermediate Customer";
        ApprovalsMgmtSqBase: Codeunit "Approvals Mgmt SqBase";
    begin
        if not IntermediateCustomer.GetBySystemId(Rec.SystemId) then
            Error(CannotFindIntCustomerErr, Rec.SystemId);

        ApprovalsMgmtSqBase.OnCancelIntCustomerForApproval(Rec);
        WorkflowWebhookManagement.FindAndCancel(Rec.RecordId);

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"Intermediate Customers - API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    var
        ApprovalsMgmtSqBase: Codeunit "Approvals Mgmt SqBase";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        CannotFindIntCustomerErr: Label 'Intermediate Customer with ID %1 cannot be found.', Comment = '%1 - the System ID of the Intermediate Customer';
}