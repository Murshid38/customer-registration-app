codeunit 50706 "Workflow Rpns Handling SqBase"
{
    // MM(+) [1109]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean);
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        Case RecRef.Number of
            Database::"Intermediate Customer":
                Begin
                    RecRef.SetTable(IntermediateCustomer);
                    IntermediateCustomer."Approval Status" := IntermediateCustomer."Approval Status"::Open;
                    IntermediateCustomer.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean);
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        Case RecRef.Number of
            Database::"Intermediate Customer":
                Begin
                    RecRef.SetTable(IntermediateCustomer);
                    IntermediateCustomer."Approval Status" := IntermediateCustomer."Approval Status"::Released;
                    IntermediateCustomer.Modify();
                    Handled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean);
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        Case RecRef.Number of
            Database::"Intermediate Customer":
                Begin
                    RecRef.SetTable(IntermediateCustomer);
                    IntermediateCustomer."Approval Status" := IntermediateCustomer."Approval Status"::"Pending Approval";
                    IntermediateCustomer.Modify();
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure OnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128]);
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WorkflowEventHandling: Codeunit "Workflow Event Handling SqBase";
    begin
        Case ResponseFunctionName of
            WorkflowResponseHandling.SetStatusToPendingApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SetStatusToPendingApprovalCode(),
                    WorkflowEventHandling.RunWorkflowOnSendIntCustomerForApprovalCode());
            WorkflowResponseHandling.SendApprovalRequestForApprovalCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.SendApprovalRequestForApprovalCode(),
            WorkflowEventHandling.RunWorkflowOnSendIntCustomerForApprovalCode());
            WorkflowResponseHandling.CancelAllApprovalRequestsCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.CancelAllApprovalRequestsCode(),
                    WorkflowEventHandling.RunWorkflowOnCancelIntCustomerForApprovalCode());
            WorkflowResponseHandling.OpenDocumentCode():
                WorkflowResponseHandling.AddResponsePredecessor(WorkflowResponseHandling.OpenDocumentCode(),
                    WorkflowEventHandling.RunWorkflowOnCancelIntCustomerForApprovalCode());
        end;
    end;
    // MM(-) [1109]

    // MM(+) [2064]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', false, false)]
    local procedure AddWorkflowResponsesToLibrary()
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        WorkflowResponseHandling.AddResponseToLibrary(PostGeneralJournalLineAsyncCode(), 0, BackgroundGenralJournalLinePostTxt, 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
    procedure ExecuteMyWorkflowResponses(ResponseWorkflowStepInstance: Record "Workflow Step Instance"; var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant)
    var
        WorkflowResponse: record "Workflow Response";
    begin
        if WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                PostGeneralJournalLineAsyncCode():
                    BEGIN
                        PostGeneralJounralLineAsync(Variant);
                        ResponseExecuted := TRUE;
                    END;
            END;
    end;

    procedure PostGeneralJournalLineAsyncCode(): Code[128]
    begin
        exit('BACKGROUNDPOSTAPPROVEDGENERALJOURNALLINE');
    end;

    procedure PostGeneralJounralLineAsync(Variant: Variant)
    var
        JobQueueEntry: Record "Job Queue Entry";
        GenJournalBatch: Record "Gen. Journal Batch";
        GenJournalLine: Record "Gen. Journal Line";
        RecRef: RecordRef;
        RecRefGenJnlLine: RecordRef;
    begin
        RecRef.GetTable(Variant);

        if RecRef.Number = Database::"Gen. Journal Line" then begin
            GenJournalLine := Variant;
            if RecRefGenJnlLine.Get(GenJournalLine.RecordId) then
                JobQueueEntry.ScheduleJobQueueEntry(CODEUNIT::"Gen. Jnl.-Post via Job Queue", RecRefGenJnlLine.RecordId);
        end
        else
            Error(UnsupportedRecordTypeErr, RecRef.Caption);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsePredecessorsToLibrary', '', false, false)]
    local procedure AddMyworkflowEventOnAddWorkflowResponsePredecessorsToLibrary(ResponseFunctionName: Code[128])
    var
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
    begin
        Case ResponseFunctionName of
            PostGeneralJournalLineAsyncCode():
                WorkflowResponseHandling.AddResponsePredecessor(PostGeneralJournalLineAsyncCode(), WorkflowEventHandling.RunWorkflowOnApproveApprovalRequestCode());
        End
    end;


    var
        BackgroundGenralJournalLinePostTxt: Label 'Post the General Journal Line in the background.';
        UnsupportedRecordTypeErr: Label 'Record type %1 is not supported by this workflow response.', Comment = 'Record type Customer is not supported by this workflow response.';
    // MM(-) [2064]
}