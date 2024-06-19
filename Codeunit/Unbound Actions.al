codeunit 50100 "Unbound Actions"
{
    procedure SendApprovalRequest(SystemId: Guid)
    //systemId should be lowercased in request body 
    var
        IntermediateCustomer: Record "Intermediate Customer";
    begin
        if not IntermediateCustomer.GetBySystemId(SystemId) then
            Error(CannotFindIntCustomerErr, SystemId);

        if IntermediateCustomer."Approval Status" = IntermediateCustomer."Approval Status"::Open then begin
            IntermediateCustomer."Approval Status" := IntermediateCustomer."Approval Status"::"Pending Approval";
            IntermediateCustomer.Modify();
        end;
    end;

    var
        CannotFindIntCustomerErr: Label 'Intermediate Customer with ID %1 cannot be found.', Comment = '%1 - the System ID of the Intermediate Customer';
}