const String transferReferenceTypeSource = 'INTERNAL_TRANSFER_SOURCE';
const String internalTransferConceptName = 'TRANSFER_INTERNAL';

bool isInternalTransferConcept(String? conceptName) {
  return conceptName?.trim().toUpperCase() == internalTransferConceptName;
}
