page 50701 "Intermediate Customer Card"
{
    Caption = 'Intermediate Customer Card';
    PageType = Card;
    SourceTable = "Intermediate Customer";
    RefreshOnActivate = true;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                Caption = 'General';

                field(No; Rec.No) { }
                field(Name; Rec.Name) { }
                field(Address; Rec.Address) { }
                field(City; Rec.City) { }
                field(PhoneNo; Rec.PhoneNo) { }
                field("Approval Status"; Rec."Approval Status")
                {
                    StyleExpr = StyleTextExpr;
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Convert To Customer")
            {
                Caption = 'Convert To Customer';
                ApplicationArea = All;
                Image = ChangeCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;
                ToolTip = 'Convert Intermediate Customer to Customer.';

                trigger OnAction()
                var
                begin
                    Rec.ConvertToCustomer();
                end;
            }
            action(SendApprovalRequests)
            {
                Enabled = NOT OpenApprovalEntriesExist AND CanRequestApprovalForFlow;
                Image = SendApprovalRequest;
                Caption = 'Send Approval Request';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                ToolTip = 'Request approval of the document.';

                trigger OnAction()
                begin
                    if ApprovalsMgmt.CheckIntCustomerApprovalsWorkflowEnable(Rec) then
                        ApprovalsMgmt.OnSendIntCustomerForApproval(Rec)
                end;
            }
            action(CancelApprovalRequest)
            {
                Enabled = CanCancelApprovalForRecord OR CanCancelApprovalForFlow;
                Image = CancelApprovalRequest;
                Caption = 'Cancel Approval Request';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                ApplicationArea = All;
                ToolTip = 'Cancel the approval request.';

                trigger OnAction()
                begin
                    ApprovalsMgmt.OnCancelIntCustomerForApproval(Rec);
                    WorkflowWebhookMgt.FindAndCancel(Rec.RecordId);
                    IsPendingApproval := false;
                    CurrPage.Update();
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetNoFromNoSeries();
    end;

    trigger OnAfterGetCurrRecord()
    var
        myInt: Integer;
    begin
        OpenApprovalEntriesExist := ApprovalMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        WorkflowWebhookMgt.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);
        StyleTextExpr := Rec.GetStatusStyleText();
    end;

    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt SqBase";
        ApprovalMgmt: Codeunit "Approvals Mgmt.";
        WorkflowWebhookMgt: Codeunit "Workflow Webhook Management";
        CanCancelApprovalForRecord: Boolean;
        CanCancelApprovalForFlow: Boolean;
        IsPendingApproval: Boolean;
        OpenApprovalEntriesExist: Boolean;
        CanRequestApprovalForFlow: Boolean;
        StyleTextExpr: Text;
}