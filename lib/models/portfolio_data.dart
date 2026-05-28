class PortfolioData {
  final HeroData hero;
  final AboutData about;
  final SkillsData skills;
  final ProjectsData projects;
  final List<CertificateItem> certificates;
  final ContactData contact;

  PortfolioData({
    required this.hero,
    required this.about,
    required this.skills,
    required this.projects,
    required this.certificates,
    required this.contact,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      hero: HeroData.fromJson(json['hero']),
      about: AboutData.fromJson(json['about']),
      skills: SkillsData.fromJson(json['skills'] ?? {}),
      projects: ProjectsData.fromJson(json['projects']),
      certificates: (json['certificates'] as List? ?? [])
          .map((e) => CertificateItem.fromJson(e))
          .toList(),
      contact: ContactData.fromJson(json['contact']),
    );
  }
}

class HeroData {
  final String greeting;
  final String name;
  final String role;
  final String description;
  final String buttonText;
  final String resumeLink;
  final String imagePath;

  HeroData({
    required this.greeting,
    required this.name,
    required this.role,
    required this.description,
    required this.buttonText,
    required this.resumeLink,
    required this.imagePath,
  });

  factory HeroData.fromJson(Map<String, dynamic> json) {
    return HeroData(
      greeting: json['greeting'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      description: json['description'] ?? '',
      buttonText: json['buttonText'] ?? '',
      resumeLink: json['resumeLink'] ?? '',
      imagePath: json['imagePath'] ?? '',
    );
  }
}

class SkillsData {
  final String sectionTitle;
  final String subtitle;
  final List<SkillCategory> categories;

  SkillsData({
    required this.sectionTitle,
    required this.subtitle,
    required this.categories,
  });

  factory SkillsData.fromJson(Map<String, dynamic> json) {
    return SkillsData(
      sectionTitle: json['sectionTitle'] ?? '',
      subtitle: json['subtitle'] ?? '',
      categories: (json['categories'] as List? ?? [])
          .map((e) => SkillCategory.fromJson(e))
          .toList(),
    );
  }
}

class SkillCategory {
  final String name;
  final String icon;
  final List<SkillItem> items;

  SkillCategory({
    required this.name,
    required this.icon,
    required this.items,
  });

  factory SkillCategory.fromJson(Map<String, dynamic> json) {
    return SkillCategory(
      name: json['name'] ?? '',
      icon: json['icon'] ?? 'code',
      items: (json['items'] as List? ?? [])
          .map((e) => SkillItem.fromJson(e))
          .toList(),
    );
  }
}

class SkillItem {
  final String name;
  final int level;

  SkillItem({
    required this.name,
    required this.level,
  });

  factory SkillItem.fromJson(Map<String, dynamic> json) {
    return SkillItem(
      name: json['name'] ?? '',
      level: json['level'] ?? 0,
    );
  }
}

class AboutData {
  final String sectionTitle;
  final String description1;
  final String description2;
  final List<String> skills;
  final String profileIcon;

  AboutData({
    required this.sectionTitle,
    required this.description1,
    required this.description2,
    required this.skills,
    required this.profileIcon,
  });

  factory AboutData.fromJson(Map<String, dynamic> json) {
    return AboutData(
      sectionTitle: json['sectionTitle'] ?? '',
      description1: json['description1'] ?? '',
      description2: json['description2'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      profileIcon: json['profileIcon'] ?? '',
    );
  }
}

class ProjectsData {
  final String sectionTitle;
  final String clientProjectsTitle;
  final String personalProjectsTitle;
  final List<ProjectItem> clientProjects;
  final List<ProjectItem> personalProjects;

  ProjectsData({
    required this.sectionTitle,
    required this.clientProjectsTitle,
    required this.personalProjectsTitle,
    required this.clientProjects,
    required this.personalProjects,
  });

  factory ProjectsData.fromJson(Map<String, dynamic> json) {
    var clientList = json['clientProjects'] as List? ?? [];
    List<ProjectItem> clientProjects = clientList
        .map((i) => ProjectItem.fromJson(i))
        .toList();

    var personalList = json['personalProjects'] as List? ?? [];
    List<ProjectItem> personalProjects = personalList
        .map((i) => ProjectItem.fromJson(i))
        .toList();

    return ProjectsData(
      sectionTitle: json['sectionTitle'] ?? '',
      clientProjectsTitle: json['clientProjectsTitle'] ?? '',
      personalProjectsTitle: json['personalProjectsTitle'] ?? '',
      clientProjects: clientProjects,
      personalProjects: personalProjects,
    );
  }
}

class ProjectItem {
  final String id;
  final String title;
  final String description;
  final String fullDescription;
  final List<String> userHighlights;
  final List<String> developerHighlights;
  final List<String> features;
  final List<String> screenshots;
  final List<String> techStack;
  final String githubLink;
  final String externalLink;
  final String androidDownloadLink;
  final String iosDownloadLink;
  final String imageUrl;

  ProjectItem({
    required this.id,
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.userHighlights,
    required this.developerHighlights,
    required this.features,
    required this.screenshots,
    required this.techStack,
    required this.githubLink,
    required this.externalLink,
    required this.androidDownloadLink,
    required this.iosDownloadLink,
    required this.imageUrl,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      fullDescription: json['fullDescription'] ?? '',
      userHighlights: List<String>.from(json['userHighlights'] ?? []),
      developerHighlights: List<String>.from(json['developerHighlights'] ?? []),
      features: List<String>.from(json['features'] ?? []),
      screenshots: List<String>.from(json['screenshots'] ?? []),
      techStack: List<String>.from(json['techStack'] ?? []),
      githubLink: json['githubLink'] ?? '',
      externalLink: json['externalLink'] ?? '',
      androidDownloadLink:
          json['androidDownloadLink'] ?? json['downloadLink'] ?? '',
      iosDownloadLink: json['iosDownloadLink'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class CertificateItem {
  final String title;
  final String issuer;
  final String date;
  final String description;
  final String imageUrl;

  CertificateItem({
    required this.title,
    required this.issuer,
    required this.date,
    required this.description,
    required this.imageUrl,
  });

  factory CertificateItem.fromJson(Map<String, dynamic> json) {
    return CertificateItem(
      title: json['title'] ?? '',
      issuer: json['issuer'] ?? '',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

class ContactData {
  final String heading;
  final String title;
  final String description;
  final String buttonText;
  final String email;
  final String subject;
  final String meetingButtonText;
  final String meetingLink;
  final SocialsData socials;
  final String footerText;

  ContactData({
    required this.heading,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.email,
    required this.subject,
    required this.meetingButtonText,
    required this.meetingLink,
    required this.socials,
    required this.footerText,
  });

  factory ContactData.fromJson(Map<String, dynamic> json) {
    return ContactData(
      heading: json['heading'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      buttonText: json['buttonText'] ?? '',
      email: json['email'] ?? '',
      subject: json['subject'] ?? '',
      meetingButtonText: json['meetingButtonText'] ?? '',
      meetingLink: json['meetingLink'] ?? '',
      socials: SocialsData.fromJson(json['socials'] ?? {}),
      footerText: json['footerText'] ?? '',
    );
  }
}

class SocialsData {
  final String github;
  final String linkedin;
  final String twitter;

  SocialsData({
    required this.github,
    required this.linkedin,
    required this.twitter,
  });

  factory SocialsData.fromJson(Map<String, dynamic> json) {
    return SocialsData(
      github: json['github'] ?? '',
      linkedin: json['linkedin'] ?? '',
      twitter: json['twitter'] ?? '',
    );
  }
}
