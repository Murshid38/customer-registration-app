codeunit 50707 "Workflow Setup SqBase"
{
    // MM(+) [1109]
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAddWorkflowCategoriesToLibrary', '', false, false)]
    local procedure OnAddWorkflowCategoriesToLibrary();
    begin
        WorkflowSetup.InsertWorkflowCategory(IntCustomerWorkflowCategoryTxt, IntCustomerWorkflowCategoryDescTxt);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnAfterInsertApprovalsTableRelations', '', false, false)]
    local procedure OnAfterInsertApprovalsTableRelations();
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        WorkflowSetup.InsertTableRelation(Database::"Intermediate Customer", 0, Database::"Approval Entry", ApprovalEntry.FieldNo("Record ID to Approve"));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Setup", 'OnInsertWorkflowTemplates', '', false, false)]
    local procedure OnInsertWorkflowTemplates(var Sender: Codeunit "Workflow Setup");
    begin
        InsertIntCustomerApprovalWorkflowTemplate();
    end;

    local procedure InsertIntCustomerApprovalWorkflowTemplate()
    var
        WorkFlow: Record Workflow;
    begin
        WorkflowSetup.InsertWorkflowTemplate(Workflow, IntCustomerApprovalWorkflowCodeTxt, IntCustomerApprovalWorkfowDescTxt, IntCustomerWorkflowCategoryTxt);
        InsertIntCustomerApprovalWorkflowDetails(Workflow);
        WorkflowSetup.MarkWorkflowAsTemplate(Workflow);
    end;

    local procedure InsertIntCustomerApprovalWorkflowDetails(var Workflow: Record Workflow)
    var
        WorkflowSetupArgument: Record "Workflow Step Argument";
        WorkflowEventHandling: Codeunit "Workflow Event Handling SqBase";
        BlankDateFormula: DateFormula;
    begin
        WorkflowSetup.InitWorkflowStepArgument(WorkflowSetupArgument, WorkflowSetupArgument."Approver Type"::Approver, WorkflowSetupArgument."Approver Limit Type"::"Direct Approver",
        0, '', BlankDateFormula, True);

        WorkflowSetup.InsertDocApprovalWorkflowSteps(
            Workflow,
            BuildIntCustomerTypeConditions(0),
            WorkflowEventHandling.RunWorkflowOnSendIntCustomerForApprovalCode(),
            BuildIntCustomerTypeConditions(1),
            WorkflowEventHandling.RunWorkflowOnCancelIntCustomerForApprovalCode(),
            WorkflowSetupArgument,
            True);
    end;

    local procedure BuildIntCustomerTypeConditions(Status: Integer): Text
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        IntermediateCustomer.SetRange("Approval Status", Status);
        exit(StrSubstNo(IntCustomerTypeCondTxt, WorkflowSetup.Encode(IntermediateCustomer.GetView(False))));
    end;

    var
        WorkflowSetup: Codeunit "Workflow Setup";
        IntCustomerWorkflowCategoryTxt: TextConst ENU = 'IntCustomer';
        IntCustomerWorkflowCategoryDescTxt: TextConst ENU = 'Intermediate Customer';
        IntCustomerApprovalWorkflowCodeTxt: TextConst ENU = 'IntCustomerAW';
        IntCustomerApprovalWorkfowDescTxt: TextConst ENU = 'Intermediate Customer Approval Workflow';
        IntCustomerTypeCondTxt: TextConst ENU = '<?xml version="1.0" encoding="utf-8" standalone="yes"?><ReportParameters><DataItems><DataItem name="Intermediate Customer">%1</DataItem></DataItems></ReportParameters>';
    // MM(-) [1109]
}