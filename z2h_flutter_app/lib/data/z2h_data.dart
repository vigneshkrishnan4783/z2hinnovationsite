import 'package:flutter/material.dart';

class ServiceItem {
  const ServiceItem({
    required this.category,
    required this.badge,
    required this.title,
    required this.description,
    required this.highlights,
    required this.tags,
    required this.icon,
    required this.accent,
  });

  final String category; // 'consulting' | 'engineering' | 'ai'
  final String badge;
  final String title;
  final String description;
  final List<String> highlights;
  final List<String> tags;
  final IconData icon;
  final Color accent;
}

class CareerRole {
  const CareerRole({
    required this.category,
    required this.title,
    required this.location,
    required this.type,
    required this.stack,
  });

  final String category; // 'ai' | 'flutter' | 'backend'
  final String title;
  final String location;
  final String type;
  final String stack;
}

class ObjectiveItem {
  const ObjectiveItem({
    required this.title,
    required this.description,
    required this.tags,
    required this.icon,
  });

  final String title;
  final String description;
  final List<String> tags;
  final IconData icon;
}

class Z2HData {
  static const companyName = 'Z2H Innovations & R&D Lab';
  static const shortName = 'Z2H Innovations';
  static const tagline = 'R&D Lab';
  static const heroHeadline =
      'Engineering AI Solutions with LLMs & Deep Learning — From Zero to Market';
  static const heroDescription =
      'Z2H Innovations & R&D Lab helps startups and businesses turn ideas into market-ready products. We offer AI solution development, freelance software development, API and backend engineering, and IT consulting.';
  static const addressLines = [
    'Z2H Innovations & R&D Lab',
    'M37, Kuruvankonam, Kowdiar',
    'Thiruvananthapuram – 695003',
    'Kerala, India',
  ];
  static const poweredBy = 'Powered by Z2H 2026';

  static const objectives = [
    ObjectiveItem(
      title: 'IT Consultancy & Freelance Pods',
      description:
          'Senior technical advisory and agile freelance engineering squads that accelerate product delivery without enterprise overhead.',
      tags: ['Architecture', 'CTO Advisory'],
      icon: Icons.groups_rounded,
    ),
    ObjectiveItem(
      title: 'Hybrid Web & Mobile Apps',
      description:
          'Single-codebase Flutter applications calibrated for crisp responsiveness on iPhone, Android, tablets, and desktop screens.',
      tags: ['Flutter', 'Responsive UI'],
      icon: Icons.devices_rounded,
    ),
    ObjectiveItem(
      title: 'Scalable Backend Services',
      description:
          'Secure backend web applications, REST/GraphQL microservices, and Hibernate ORM persistence engineered for high uptime.',
      tags: ['Hibernate ORM', 'Cloud APIs'],
      icon: Icons.dns_rounded,
    ),
    ObjectiveItem(
      title: 'LLM & Deep Learning R&D',
      description:
          'Dedicated research into Large Language Models, deep learning pipelines, and custom neural architectures built for real-world impact.',
      tags: ['LLM Agents', 'Deep R&D'],
      icon: Icons.psychology_rounded,
    ),
  ];

  static const services = [
    ServiceItem(
      category: 'consulting',
      badge: 'CONSULTING',
      title: 'IT Consultancy & Architecture Strategy',
      description:
          'End-to-end technology roadmapping, cloud cost optimization, system audits, and CTO-level advisory for founders and enterprises.',
      highlights: [
        'Scalability & security architecture reviews',
        'Build-vs-buy & AI readiness blueprints',
      ],
      tags: ['Advisory', 'Cloud Strategy'],
      icon: Icons.architecture_rounded,
      accent: Color(0xFF00E5FF),
    ),
    ServiceItem(
      category: 'consulting',
      badge: 'FREELANCE PODS',
      title: 'Agile Freelance Engineering & IT Services',
      description:
          'On-demand, high-ownership freelance developers and cross-functional squads ready to ship features or accelerate MVPs.',
      highlights: [
        'Weekly sprint milestones & clean documentation',
        'Flexible hourly or milestone engagements',
      ],
      tags: ['Dedicated Devs', 'Rapid MVP'],
      icon: Icons.bolt_rounded,
      accent: Color(0xFF6366F1),
    ),
    ServiceItem(
      category: 'engineering',
      badge: 'HYBRID APPS',
      title: 'Hybrid Web & Mobile App Development',
      description:
          'Flutter cross-platform applications delivering fluid native-grade UI across iPhone, Android, tablets, and desktop browsers.',
      highlights: [
        'Adaptive layouts across all screen resolutions',
        'Offline sync, push notifications & store readiness',
      ],
      tags: ['Flutter', 'iPhone & Android', 'Web'],
      icon: Icons.phone_iphone_rounded,
      accent: Color(0xFF00E5FF),
    ),
    ServiceItem(
      category: 'engineering',
      badge: 'BACKEND SYSTEMS',
      title: 'Backend Web Apps & Enterprise APIs',
      description:
          'Resilient server architectures featuring Hibernate/ORM relational data layers, REST & GraphQL APIs, and automated CI/CD.',
      highlights: [
        'Java/Hibernate, Python & Node microservices',
        'Containerized high-availability deployment',
      ],
      tags: ['Hibernate ORM', 'Microservices'],
      icon: Icons.storage_rounded,
      accent: Color(0xFF6366F1),
    ),
    ServiceItem(
      category: 'ai',
      badge: 'LLM AI PROJECTS',
      title: 'Generative AI, RAG & Autonomous Agents',
      description:
          'Custom LLM applications grounded in private enterprise data—document intelligence, AI copilots, and workflow automation.',
      highlights: [
        'Vector retrieval & hallucination guardrails',
        'Open-weights & cloud model orchestration',
      ],
      tags: ['RAG', 'AI Agents', 'Fine-Tuning'],
      icon: Icons.auto_awesome_rounded,
      accent: Color(0xFF10B981),
    ),
    ServiceItem(
      category: 'ai',
      badge: 'DEEP LEARNING R&D',
      title: 'Deep Learning & Applied AI Research',
      description:
          'Applied R&D for computer vision, predictive analytics, and multi-stage neural pipelines tailored to real-world verticals.',
      highlights: [
        'Custom dataset curation & model training',
        'Edge & cloud inference optimization',
      ],
      tags: ['PyTorch', 'Vision & NLP', 'R&D Lab'],
      icon: Icons.hub_rounded,
      accent: Color(0xFF10B981),
    ),
  ];

  static const roles = [
    CareerRole(
      category: 'ai',
      title: 'Deep Learning & LLM Research Engineer',
      location: 'Thiruvananthapuram / Hybrid',
      type: 'Full-Time',
      stack: 'PyTorch, RAG, AI Agents',
    ),
    CareerRole(
      category: 'flutter',
      title: 'Senior Flutter & Hybrid App Developer',
      location: 'Thiruvananthapuram / Remote',
      type: 'Full-Time',
      stack: 'Flutter, Dart, Responsive UI',
    ),
    CareerRole(
      category: 'backend',
      title: 'Backend Systems Architect (APIs & Hibernate/ORM)',
      location: 'Thiruvananthapuram / Hybrid',
      type: 'Full-Time',
      stack: 'Java/Hibernate, Python, Cloud',
    ),
    CareerRole(
      category: 'backend',
      title: 'Associate IT Consultant & Freelance Delivery Lead',
      location: 'Kuruvankonam, Kowdiar',
      type: 'Full-Time / Contract',
      stack: 'Agile Delivery, Client Architecture',
    ),
  ];
}
