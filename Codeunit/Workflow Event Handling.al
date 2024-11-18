codeunit 50705 "Workflow Event Handling SqBase"
{
    // MM(+) [1109]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventsToLibrary();
    begin
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnSendIntCustomerForApprovalCode(), Database::"Intermediate Customer", IntCustomerSendForApprovalEventDescTxt, 0, false);
        WorkflowEventHandling.AddEventToLibrary(RunWorkflowOnCancelIntCustomerForApprovalCode(), Database::"Intermediate Customer", IntCustomerApprovalReuqestCancelEventDescText, 0, false);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventPredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowEventPredecessorsToLibrary(EventFunctionName: Code[128]);
    begin
        case EventFunctionName of
            RunWorkflowOnCancelIntCustomerForApprovalCode():
                WorkflowEventHandling.AddEventPredecessor(RunWorkflowOnCancelIntCustomerForApprovalCode(), RunWorkflowOnSendIntCustomerForApprovalCode());

            WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode():
                WorkflowEventHandling.AddEventPredecessor(WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode(), RunWorkflowOnSendIntCustomerForApprovalCode());
        end;
    end;

    procedure RunWorkflowOnSendIntCustomerForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnSendIntCustomerForApproval'));
    end;

    procedure RunWorkflowOnCancelIntCustomerForApprovalCode(): Code[128]
    begin
        exit(UpperCase('RunWorkflowOnCancelIntCustomerForApproval'));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt SqBase", 'OnSendIntCustomerForApproval', '', false, false)]
    local procedure OnSendIntCustomerForApproval(var IntermediateCustomer: Record "Intermediate Customer");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnSendIntCustomerForApprovalCode(), IntermediateCustomer);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt SqBase", 'OnCancelIntCustomerForApproval', '', false, false)]
    local procedure OnCancelIntCustomerForApproval(var IntermediateCustomer: Record "Intermediate Customer");
    begin
        WorkflowManagment.HandleEvent(RunWorkflowOnCancelIntCustomerForApprovalCode(), IntermediateCustomer);
    end;

    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowManagment: Codeunit "Workflow Management";
        IntCustomerSendForApprovalEventDescTxt: TextConst ENU = 'Approval of a Intermediate Customer is required';
        IntCustomerApprovalReuqestCancelEventDescText: TextConst ENU = 'Approval of a Intermediate Customer is canceled';
    // MM(-) [1109]
}