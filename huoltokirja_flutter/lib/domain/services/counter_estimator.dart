int estimateCounter({required int latestCounter, int? targetCounter}) {
  if (targetCounter == null) return latestCounter;
  return targetCounter < latestCounter ? latestCounter : targetCounter;
}
