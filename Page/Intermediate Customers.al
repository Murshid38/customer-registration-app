page 50101 "Intermediate Customer List"
{
    Caption = 'Intermediate Customers';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Intermediate Customer";
    CardPageId = "Intermediate Customer Card";
    DataCaptionFields = No, Name;

    layout
    {
        area(Content)
        {
            repeater(Group)
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
            action(ActionName)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin

                end;
            }
        }
    }
}