page 50100 "Intermediate Customer Card"
{
    Caption = 'Intermediate Customer Card';
    PageType = Card;
    SourceTable = "Intermediate Customer";
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field(No; Rec.No)
                {
                    ApplicationArea = All;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                }
                field("Approval Status"; Rec."Approval Status")
                {
                    ApplicationArea = All;
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
                ApplicationArea = All;
                Image = ChangeCustomer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Customer: Record Customer;
                begin
                    Rec.TestField("Approval Status", Rec."Approval Status"::Released);
                end;
            }
        }
    }
}