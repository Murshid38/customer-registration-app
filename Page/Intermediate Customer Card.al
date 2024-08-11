page 50100 "Intermediate Customer Card"
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
                field("Approval Status"; Rec."Approval Status") { }
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
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetNoFromNoSeries();
    end;
}