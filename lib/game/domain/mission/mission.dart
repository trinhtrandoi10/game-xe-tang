import '../../../core/math/game_vector.dart';

enum MissionStage {
  reachTown,
  destroyScouts,
  captureRadar,
  defendRadar,
  complete,
  failed
}

class MissionRuntime {
  MissionRuntime({this.stage = MissionStage.reachTown});

  MissionStage stage;
  double captureProgress = 0;
  double defendRemaining = 45;
  int destroyedScouts = 0;
  bool rewardClaimed = false;
  double elapsed = 0;

  String get objectiveKey => switch (stage) {
        MissionStage.reachTown => 'objectiveReach',
        MissionStage.destroyScouts => 'objectiveDestroy',
        MissionStage.captureRadar => 'objectiveCapture',
        MissionStage.defendRadar => 'objectiveDefend',
        MissionStage.complete => 'objectiveComplete',
        MissionStage.failed => 'objectiveFailure',
      };

  String get stageCode => stage.name;

  void restoreFromProfile({
    required String stageCode,
    required double captureProgress,
    required double defendRemaining,
    required int destroyedScouts,
    required bool rewardClaimed,
  }) {
    stage = MissionStage.values.firstWhere(
      (candidate) => candidate.name == stageCode,
      orElse: () => MissionStage.reachTown,
    );
    this.captureProgress = captureProgress.clamp(0, 1).toDouble();
    this.defendRemaining = defendRemaining.clamp(0, 45).toDouble();
    this.destroyedScouts = destroyedScouts.clamp(0, 99);
    this.rewardClaimed = rewardClaimed;
  }

  double get progress => switch (stage) {
        MissionStage.reachTown => 0,
        MissionStage.destroyScouts => destroyedScouts / 2,
        MissionStage.captureRadar => captureProgress,
        MissionStage.defendRadar => 1 - defendRemaining / 45,
        MissionStage.complete => 1,
        MissionStage.failed => 0,
      };

  GameVector targetForStage() => switch (stage) {
        MissionStage.reachTown => const GameVector(-10, -10),
        MissionStage.destroyScouts => const GameVector(70, -35),
        MissionStage.captureRadar ||
        MissionStage.defendRadar ||
        MissionStage.complete =>
          const GameVector(290, 0),
        MissionStage.failed => const GameVector(0, 0),
      };
}
