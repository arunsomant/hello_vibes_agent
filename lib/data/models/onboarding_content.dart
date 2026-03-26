class OnboardingContent {
  final String title;
  final String description;

  OnboardingContent({required this.title, required this.description});

  static List<OnboardingContent> onboardingContents() => [
    OnboardingContent(
      title: 'Let\'s meet new people',
      description:
          'Discover and connect with interesting people for friendly video and audio chat',
    ),
    OnboardingContent(
      title: 'Stay Close, Anywhere',
      description:
          'Enjoy high-quality video and crystal-clear audio that makes you feel like you\'re in the same room, no matter where you are',
    ),
    OnboardingContent(
      title: 'Private & Secure conversations',
      description:
          'All your calls are end-to-end encrypted, so your personal moments stay between you and your contact',
    ),
  ];
}
