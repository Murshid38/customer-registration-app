codeunit 50701 "Event Subscribers"
{
    #region Doc Attachment
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", OnBeforeDrillDown, '', false, false)]
    local procedure RunOnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        case DocumentAttachment."Table ID" of
            Database::"Intermediate Customer":
                begin
                    RecRef.Open(Database::"Intermediate Customer");
                    if IntermediateCustomer.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(IntermediateCustomer);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", OnAfterOpenForRecRef, '', false, false)]
    local procedure RunOnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            Database::"Intermediate Customer":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", OnAfterInitFieldsFromRecRef, '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            Database::"Intermediate Customer":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
    #endregion
}