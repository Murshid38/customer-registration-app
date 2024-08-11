page 50101 "Intermediate Customer List"
{
    Caption = 'Intermediate Customers';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = "Intermediate Customer";
    CardPageId = "Intermediate Customer Card";
    DataCaptionFields = No, Name;
    RefreshOnActivate = true;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(No; Rec.No) { }
                field(Name; Rec.Name) { }
                field("Approval Status"; Rec."Approval Status") { }
            }
        }

        area(FactBoxes)
        {
            part("Attached Document"; "Document Attachment Factbox")
            {
                Caption = 'Attachments';
                SubPageLink = "Table ID" = const(Database::"Intermediate Customer"), "No." = field(No);
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetNoFromNoSeries();
    end;
}