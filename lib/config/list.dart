import 'package:employeeform/config/images.dart';

import '../model/com_profile_model.dart';

List<String> employeeNumbers = [
  "1 - 5",
  "5 - 10",
  "10 - 20",
  "20 - 50",
  "50 - 100",
  "100 +"
];
Map<String, dynamic> myData = {
  'image': "assets/images/Illustration.png",
  'name': "image",
  'desc':
      "Free delivery for new customers via Apple Pay and others payment methods."
};

List<Map<String, dynamic>> employeelistdata = [
  {
    'label': "Employee \nDetails",
    'image': "assets/images/EmployeeDetails.svg",
  },
  {
    'label': "Attendance\n",
    'image': "assets/images/Attendance.svg",
  },
  {
    'label': "Report\n",
    'image': "assets/images/Report.svg",
  },
/*  {
    'label': "Employee \nTask",
    'image': "assets/images/Employeetask.svg",
  },*/
  {
    'label': "All \nTask",
    'image': "assets/images/Alltask.svg",
  },
  {
    'label': "Task \nReport",
    'image': "assets/images/TaskReport.svg",
  },
  {
    'label': "Employee \nAttendance",
    'image': "assets/images/EmployeeAttendance.svg",
  },
];

List<Map<String, dynamic>> userdashboardlist = [
  {
    'label': "Profile \n",
    'image': "assets/images/profile.svg",
  },
  {
    'label': "Task\n",
    'image': "assets/images/TaskReport.svg",
  },
  {
    'label': "Attendance\n",
    'image': "assets/images/EmployeeAttendance.svg",
  },
];

List<Map<String, dynamic>> attendanceDatalist = [
  {'date': '28/11/2024', 'in': '9:00 AM', 'out': '6:00 PM'},
  {'date': '27/11/2024', 'in': '9:15 AM', 'out': '6:05 PM'},
  {'date': '26/11/2024', 'in': '8:50 AM', 'out': '5:55 PM'},
  {'date': '28/11/2024', 'in': '9:00 AM', 'out': '6:00 PM'},
  {'date': '27/11/2024', 'in': '9:15 AM', 'out': '6:05 PM'},
  {'date': '26/11/2024', 'in': '8:50 AM', 'out': '5:55 PM'},
];

List<String> items = ['USA', 'India', 'Canada'];
List<String> itemsbank = [
  'SBI',
  'Axis Bank',
  'ICICI Bank',
  'HDFC Bank',
  'Bank of Baroda'
];
List<String> taskstatus = [
  'Pending',
  'Hold',
];
List<IndustryModel> industryList = [
  IndustryModel(
    title: "Information Technology",
    services: [
      "Mobile App Development",
      "Web Development",
      "Flutter Development",
      "Software Development",
      "Cloud Computing",
      "Cybersecurity",
      "AI & Machine Learning",
      "IT Consulting"
    ],
  ),
  IndustryModel(
    title: "Healthcare",
    services: [
      "Medical Software",
      "Telemedicine",
      "Pharmacy Management",
      "Electronic Health Records",
      "Hospital Management Systems",
      "Healthcare Analytics",
      "Medical Imaging Software",
      "Wearable Health Tech"
    ],
  ),
  IndustryModel(
    title: "Finance",
    services: [
      "Banking Solutions",
      "Stock Market Software",
      "Insurance Tech",
      "Fintech Solutions",
      "Cryptocurrency & Blockchain",
      "Wealth Management Software",
      "Accounting & Tax Software",
      "Risk Management Systems"
    ],
  ),
  IndustryModel(
    title: "Education",
    services: [
      "E-learning Platforms",
      "School Management Software",
      "Online Course Development",
      "Student Information Systems",
      "Virtual Classrooms",
      "LMS (Learning Management System)",
      "AI in Education",
      "Skill Development Platforms"
    ],
  ),
  IndustryModel(
    title: "Manufacturing",
    services: [
      "ERP Solutions",
      "Inventory Management",
      "Supply Chain Management",
      "Automated Manufacturing Systems",
      "Quality Control Software",
      "Production Planning",
      "Warehouse Management",
      "Industrial IoT"
    ],
  ),
  IndustryModel(
    title: "Retail",
    services: [
      "E-commerce Development",
      "POS Software",
      "Customer Relationship Management",
      "Inventory Tracking",
      "Omnichannel Retail Solutions",
      "Digital Payment Solutions",
      "Retail Analytics",
      "Loyalty Program Software"
    ],
  ),
  IndustryModel(
    title: "Construction",
    services: [
      "Project Management Software",
      "Building Information Modeling (BIM)",
      "Construction Estimating Software",
      "Equipment Tracking",
      "Architectural Design Software",
      "Safety & Compliance Solutions",
      "Contractor Management",
      "Real-time Collaboration Tools"
    ],
  ),
  IndustryModel(
    title: "Real Estate",
    services: [
      "Property Management Software",
      "Real Estate CRM",
      "Virtual Tours & 3D Visualization",
      "Home Listing Platforms",
      "Rental Management Solutions",
      "Mortgage & Loan Software",
      "AI-Powered Real Estate Insights",
      "Legal Document Management"
    ],
  ),
  IndustryModel(
    title: "Transportation",
    services: [
      "Fleet Management",
      "Logistics & Supply Chain Solutions",
      "Public Transportation Management",
      "Ride-sharing & Mobility Solutions",
      "Automated Dispatching Systems",
      "Route Optimization Software",
      "Freight & Cargo Management",
      "Vehicle Telematics"
    ],
  ),
  IndustryModel(
    title: "Media & Entertainment",
    services: [
      "Video Streaming Platforms",
      "Music Streaming Services",
      "Content Management Systems",
      "Game Development",
      "AR/VR Solutions",
      "Digital Advertising",
      "Social Media Management",
      "Event Ticketing Platforms"
    ],
  ),
  IndustryModel(
    title: "Hospitality",
    services: [
      "Hotel Management Software",
      "Restaurant POS Systems",
      "Event Planning Platforms",
      "Guest Experience & Booking Systems",
      "Travel & Tourism Solutions",
      "Revenue Management Software",
      "Customer Loyalty Programs",
      "Housekeeping Management"
    ],
  ),
  IndustryModel(
    title: "Government",
    services: [
      "E-Governance Solutions",
      "Public Administration Software",
      "Law Enforcement & Security Systems",
      "Tax & Revenue Management",
      "Census & Data Collection Software",
      "Citizen Engagement Platforms",
      "Disaster Management Systems"
    ],
  ),
  IndustryModel(
    title: "Automobile",
    services: [
      "Vehicle Manufacturing Software",
      "Automotive ERP Solutions",
      "Car Rental & Fleet Management",
      "Autonomous Vehicle Technology",
      "EV Charging Solutions",
      "Automobile Maintenance Systems"
    ],
  ),
  IndustryModel(
    title: "Other",
    services: [
      "Custom Services",
      "Consulting Services",
      "Outsourcing Solutions",
      "Freelance Platforms",
      "Research & Development",
      "Digital Marketing"
    ],
  ),
];

List onboardingDetail = [
  {
    'image': AppSvg.onboarding1,
    'title': 'Smart Employee Management',
    'subtitle':
        "Easily manage employee data, track attendance, and assign daily tasks with ease — all in one place.",
  },
  {
    'image': AppSvg.onboarding2,
    'title': 'Seamless Task & Leave Flow',
    'subtitle':
        "Streamline daily task assignments and leave requests with real-time tracking and efficient approvals.",
  },
  {
    'image': AppSvg.onboarding3,
    'title': 'Stay Connected & In Control',
    'subtitle':
        "From attendance tracking to leave management, your workplace is now just a tap away for both admins and employees.",
  },
  // {
  //   'image': AppSvg.onboarding1,
  //   'title': 'Fun and Interactive!',
  //   'subtitle':
  //       "Get ready for a playful journey full of surprises! Let’s dive in and see what adventures await you!"
  // },
  // {
  //   'image': AppSvg.onboarding2,
  //   'title': 'Adventure',
  //   'subtitle':
  //       "Explore magical world. Let’s get started on your exciting journey!",
  // },
  // {
  //   'image': AppSvg.onboarding3,
  //   'title': "Playful Performance!",
  //   'subtitle':
  //       "Join the cast of endless fun and adventure! Every move is a new act in your very own theater."
  // },
];

List<CountryModel> countries = [
  CountryModel(id: 1, title: "Afghanistan", states: [
    StateModel(
        id: 101,
        name: 'Badakhshan',
        cities: ['Fayzabad', 'Jurm', 'Baharak', 'Kishim', 'Shighnan']),
    StateModel(id: 102, name: 'Badghis', cities: [
      'Qala-e-Naw',
      'Bala Murghab',
      'Muqur',
      'Jawand',
      'Qadis',
      'Ab Kamari'
    ]),
    StateModel(id: 103, name: 'Balkh', cities: [
      'Mazar-i-Sharif',
      'Balkh',
      'Sholgara',
      'Dehdadi',
      'Charkint',
      'Kaldar '
    ]),
    StateModel(
        id: 104,
        name: 'Herat',
        cities: ['Herat', 'Gulran', 'Karukh', 'Obeh', 'Shindand']),
    StateModel(
        id: 105,
        name: 'Kandahar',
        cities: ['Kandahar', 'Arghandab', 'Daman', 'Maruf', 'Spin Boldak'])
  ]),
  CountryModel(id: 2, title: "Albania", states: [
    StateModel(
        id: 201,
        name: 'Berat',
        cities: ['Berat', 'Poliçan', 'Kuçovë', 'Ura Vajgurore', 'Çorovodë']),
    StateModel(
        id: 202,
        name: 'Dibër',
        cities: ['Peshkopi', 'Bulqizë', 'Burrel', 'Klos', 'Kastriot']),
    StateModel(
        id: 203,
        name: 'Fier',
        cities: ['Fier', 'Patos', 'Ballsh', 'Roskovec', 'Divjakë']),
    StateModel(
        id: 204,
        name: 'Shkodër',
        cities: ['Shkodër', 'Koplik', 'Vau i Dejës', 'Pukë', 'Fushë-Arrëz']),
    StateModel(
        id: 205,
        name: 'Tiranë',
        cities: ['Tirana', 'Kamëz', 'Vorë', 'Kashar', 'Petrelë'])
  ]),
  CountryModel(id: 3, title: "Australia", states: [
    StateModel(id: 301, name: 'New South Wales', cities: [
      'Sydney',
      'Newcastle',
      'Wollongong',
      'Central Coast',
      'Albury'
    ]),
    StateModel(id: 302, name: 'Queensland', cities: [
      'Brisbane',
      'Gold Coast',
      'Cairns',
      'Townsville',
      'Toowoomba'
    ]),
    StateModel(
        id: 303,
        name: 'Victoria',
        cities: ['Melbourne', 'Geelong', 'Ballarat', 'Bendigo', 'Shepparton']),
    StateModel(
        id: 304,
        name: 'Western Australia',
        cities: ['Perth', 'Mandurah', 'Bunbury', 'Geraldton', 'Kalgoorlie']),
    StateModel(id: 305, name: 'South Australia', cities: [
      'Adelaide',
      'Mount Gambier',
      'Murray Bridge',
      'Whyalla',
      'Port Augusta'
    ])
  ]),
  CountryModel(id: 4, title: "Brazil", states: [
    StateModel(
        id: 401,
        name: 'São Paulo',
        cities: ['São Paulo', 'Campinas', 'Santos', 'Sorocaba', 'Jundiaí']),
    StateModel(id: 402, name: 'Rio de Janeiro', cities: [
      'Rio de Janeiro',
      'Niterói',
      'Petrópolis',
      'Campos',
      'Duque de Caxias'
    ]),
    StateModel(id: 403, name: 'Bahia', cities: [
      'Salvador',
      'Feira de Santana',
      'Vitória da Conquista',
      'Ilhéus',
      'Camaçari'
    ]),
    StateModel(id: 404, name: 'Paraná', cities: [
      'Curitiba',
      'Londrina',
      'Maringá',
      'Cascavel',
      'Foz do Iguaçu'
    ]),
    StateModel(
        id: 405,
        name: 'Amazonas',
        cities: ['Manaus', 'Parintins', 'Itacoatiara', 'Tabatinga', 'Coari'])
  ]),
  CountryModel(id: 5, title: "India", states: [
    StateModel(
        id: 501,
        name: 'Maharashtra',
        cities: ['Mumbai', 'Pune', 'Nagpur', 'Nashik', 'Aurangabad']),
    StateModel(
        id: 502,
        name: 'Uttar Pradesh',
        cities: ['Lucknow', 'Kanpur', 'Varanasi', 'Agra', 'Allahabad']),
    StateModel(id: 503, name: 'Tamil Nadu', cities: [
      'Chennai',
      'Coimbatore',
      'Madurai',
      'Chidambaram',
      'Trichy',
      'Salem'
    ]),
    StateModel(
        id: 504,
        name: 'West Bengal',
        cities: ['Kolkata', 'Siliguri ', 'Durgapur', 'Asansol', 'Darjeeling']),
  ])
];
