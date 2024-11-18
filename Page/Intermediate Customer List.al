page 50702 "Intermediate Customer List"
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
                field(Address; Rec.Address) { }
                field(City; Rec.City) { }
                field(PhoneNo; Rec.PhoneNo) { }
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

    actions
    {
        area(Processing)
        {
            action(FileHandlingAction)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    InstreamObj: InStream;
                begin
                    File.UploadIntoStream('Upload a file', InstreamObj);
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetNoFromNoSeries();
    end;
}