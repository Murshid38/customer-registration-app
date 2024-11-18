codeunit 50704 "Approvals Mgmt SqBase"
{
    // MM(+) [1109]
    [IntegrationEvent(false, false)]
    procedure OnSendIntCustomerForApproval(var IntermediateCustomer: Record "Intermediate Customer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelIntCustomerForApproval(var IntermediateCustomer: Record "Intermediate Customer")
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelIntCustomerApprovalRequest(var IntermediateCustomer: Record "Intermediate Customer")
    begin
    end;

    [IntegrationEvent(false, false)]
    internal procedure OnRenameRecordInApprovalRequest(RecordId1: RecordId; RecordId2: RecordId)
    begin
    end;

    procedure CheckIntCustomerApprovalsWorkflowEnable(var IntermediateCustomer: Record "Intermediate Customer"): Boolean
    begin
        if not IsIntCustomerApprovalsWorkflowEnable(IntermediateCustomer) then
            Error(NoWorkflowEnableErr);
        exit(true);
    end;

    procedure IsIntCustomerApprovalsWorkflowEnable(var IntermediateCustomer: Record "Intermediate Customer"): Boolean
    begin
        exit(WorkflowManagment.CanExecuteWorkflow(IntermediateCustomer, WorkflowEventHandling.RunWorkflowOnSendIntCustomerForApprovalCode()));
    end;

    procedure IntCustomerPerformManualCheckAndRelease(var IntermediateCustomer: Record "Intermediate Customer")
    begin
        if IsIntCustomerApprovalsWorkflowEnable2(IntermediateCustomer) then
            Error(Error0001);

        RecordRestrictionMgt.CheckRecordHasUsageRestrictions(IntermediateCustomer);
    end;

    procedure IsIntCustomerApprovalsWorkflowEnable2(var IntermediateCustomer: Record "Intermediate Customer"): Boolean
    begin
        exit(WorkflowManagment.CanExecuteWorkflow(IntermediateCustomer, WorkflowEventHandling.RunWorkflowOnSendIntCustomerForApprovalCode()));
    end;

    procedure IsIntCustomerPendingApproval(var IntermediateCustomer: Record "Intermediate Customer")
    begin
        if IsIntCustomerApprovalsWorkflowEnable2(IntermediateCustomer) then
            Error(Error0002, IntermediateCustomer.No);

        RecordRestrictionMgt.CheckRecordHasUsageRestrictions(IntermediateCustomer);
    end;

    procedure TrySendIntCustomerApprovalRequests(var IntermediateCustomer: Record "Intermediate Customer")
    var
        LinesSent: Integer;
    begin
        if IntermediateCustomer.Count = 1 then
            if CheckIntCustomerApprovalsWorkflowEnable(IntermediateCustomer) then;
        REPEAT
            IF WorkflowManagment.CanExecuteWorkflow(IntermediateCustomer,
                 WorkflowEventHandling.RunWorkflowOnSendIntCustomerForApprovalCode()) AND
               NOT AppovalMgmt.HasOpenApprovalEntries(IntermediateCustomer.RecordId)
            THEN BEGIN
                OnSendIntCustomerForApproval(IntermediateCustomer);
                LinesSent += 1;
            END;
        UNTIL IntermediateCustomer.NEXT() = 0;

        CASE LinesSent OF
            0:
                MESSAGE(NoApprovalsSentMsg);
            IntermediateCustomer.COUNT:
                MESSAGE(PendingApprovalForSelectedLinesMsg);
            ELSE
                MESSAGE(PendingApprovalForSomeSelectedLinesMsg);
        END;
    end;

    procedure TryCancelIntCustomerApprovalRequests(var IntermediateCustomer: Record "Intermediate Customer")
    begin
        REPEAT
            IF AppovalMgmt.HasOpenApprovalEntries(IntermediateCustomer.RECORDID) THEN
                OnCancelIntCustomerForApproval(IntermediateCustomer);
            WorkflowWebhookManagement.FindAndCancel(IntermediateCustomer.RECORDID);
        UNTIL IntermediateCustomer.NEXT() = 0;
        MESSAGE(ApprovalReqCanceledForSelectedLinesMsg);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance");
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        case RecRef.Number of
            Database::"Intermediate Customer":
                begin
                    RecRef.SetTable(IntermediateCustomer);
                    ApprovalEntryArgument."Document No." := IntermediateCustomer."No";
                end;
        end;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnBeforeShowCommonApprovalStatus', '', false, false)]
    local procedure OnBeforeShowCommonApprovalStatus(var RecRef: RecordRef; var IsHandle: Boolean);
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        case RecRef.Number of
            Database::"Intermediate Customer":
                begin
                    RecRef.SetTable(IntermediateCustomer);
                    IsHandle := true;
                end;
        end;
    end;

    var
        AppovalMgmt: Codeunit "Approvals Mgmt.";
        WorkflowManagment: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling SqBase";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
        RecordRestrictionMgt: Codeunit "Record Restriction Mgt.";
        NoWorkflowEnableErr: TextConst ENU = 'No Approval workflow for this type is enabled.';
        Error0001: TextConst ENU = 'This document can only be released when the approval process is complete.';
        NoApprovalsSentMsg: TextConst ENU = 'No approval requests have been sent, either because they are already sent or because related workflows do not support the line.';
        PendingApprovalForSelectedLinesMsg: TextConst ENU = 'Approval requests have been sent.';
        PendingApprovalForSomeSelectedLinesMsg: TextConst ENU = 'Requests for some lines were not sent, either because they are already sent or because related workflows do not support the line.';
        ApprovalReqCanceledForSelectedLinesMsg: TextConst ENU = 'The approval request for the selected record has been canceled.';
        Error0002: TextConst ENU = 'Intermediate customer %1 must be approved and released before you can perform this action.';
    // MM(-) [1109]
}