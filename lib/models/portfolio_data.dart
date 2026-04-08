class PortfolioData {
  final HeroData hero;
  final AboutData about;
  final ProjectsData projects;
  final ContactData contact;

  PortfolioData({
    required this.hero,
    required this.about,
    required this.projects,
    required this.contact,
  });

  factory PortfolioData.fromJson(Map<String, dynamic> json) {
    return PortfolioData(
      hero: HeroData.fromJson(json['hero']),
      about: AboutData.fromJson(json['about']),
      projects: ProjectsData.fromJson(json['projects']),
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

  HeroData({
    required this.greeting,
    required this.name,
    required this.role,
    required this.description,
    required this.buttonText,
    required this.resumeLink,
  });

  factory HeroData.fromJson(Map<String, dynamic> json) {
    return HeroData(
      greeting: json['greeting'] ?? '',
      name: json['name'] ?? '',
      role: json['role'] ?? '',
      description: json['description'] ?? '',
      buttonText: json['buttonText'] ?? '',
      resumeLink: json['resumeLink'] ?? '',
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
    List<ProjectItem> clientProjects = clientList.map((i) => ProjectItem.fromJson(i)).toList();
    
    var personalList = json['personalProjects'] as List? ?? [];
    List<ProjectItem> personalProjects = personalList.map((i) => ProjectItem.fromJson(i)).toList();
    
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
  final List<String> features;
  final List<String> screenshots;
  final List<String> techStack;
  final String githubLink;
  final String externalLink;
  final String imageUrl;

  ProjectItem({
    required this.id,
    required this.title,
    required this.description,
    required this.fullDescription,
    required this.features,
    required this.screenshots,
    required this.techStack,
    required this.githubLink,
    required this.externalLink,
    required this.imageUrl,
  });

  factory ProjectItem.fromJson(Map<String, dynamic> json) {
    return ProjectItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      fullDescription: json['fullDescription'] ?? '',
      features: List<String>.from(json['features'] ?? []),
      screenshots: List<String>.from(json['screenshots'] ?? []),
      techStack: List<String>.from(json['techStack'] ?? []),
      githubLink: json['githubLink'] ?? '',
      externalLink: json['externalLink'] ?? '',
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
