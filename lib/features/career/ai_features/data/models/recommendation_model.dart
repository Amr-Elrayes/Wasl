class RecommendationModel {
  final String candidateSummary;
  final List<CareerPathItem> careerPaths;
  final String generalAdvice;

  RecommendationModel({
    required this.candidateSummary,
    required this.careerPaths,
    required this.generalAdvice,
  });

  factory RecommendationModel.fromJson(Map<String, dynamic> json) {
    // 1. بنمسك كائن الـ recommendations الأول لو موجود، لو مش موجود بناخد الـ json الرئيسي كـ غطاء أمان
    final recommendations = json['recommendations'] as Map<String, dynamic>? ?? json;

    return RecommendationModel(
      // 2. بنقرأ البيانات من جوه الـ recommendations
      candidateSummary: recommendations['candidate_summary'] ?? '',
      generalAdvice: recommendations['general_advice'] ?? '',
      careerPaths: (recommendations['career_paths'] as List?)
              ?.map((e) => CareerPathItem.fromJson(e))
              .toList() ?? [],
    );
  }
}

// كلاس الـ CareerPathItem يظل كما هو تماماً دون أي تعديل
class CareerPathItem {
  final String title;
  final int fitScore;
  final String rationale;
  final List<String> currentStrengths;
  final List<String> skillsToDevelop;
  final List<String> nextSteps;
  final String timeline;
  final String marketDemand;

  CareerPathItem({
    required this.title,
    required this.fitScore,
    required this.rationale,
    required this.currentStrengths,
    required this.skillsToDevelop,
    required this.nextSteps,
    required this.timeline,
    required this.marketDemand,
  });

  factory CareerPathItem.fromJson(Map<String, dynamic> json) {
    return CareerPathItem(
      title: json['title'] ?? '',
      fitScore: json['fit_score'] ?? 0,
      rationale: json['rationale'] ?? '',
      currentStrengths: List<String>.from(json['current_strengths'] ?? []),
      skillsToDevelop: List<String>.from(json['skills_to_develop'] ?? []),
      nextSteps: List<String>.from(json['next_steps'] ?? []),
      timeline: json['timeline'] ?? '',
      marketDemand: json['market_demand'] ?? '',
    );
  }
}