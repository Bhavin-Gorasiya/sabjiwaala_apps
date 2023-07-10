const String assetsPath = 'assets';
const String assetsNewImgsPath = 'assets/new_imgs';

/// Rupee sign
const String rupeeSign = "₹";

/// Horizontal padding of the whole app
const double appPaddingX = 10;

/// A dummy image if there is no image for service
const String dummyServiceImg =
    "https://st2.depositphotos.com/6903990/11216/i/450/depositphotos_112165642-stock-photo-woman-with-curly-hair-and.jpg";

/// List of images for carousel
const List<String> imgList = [
  "https://media.istockphoto.com/photos/business-woman-lady-boss-in-beauty-salon-making-hairdress-and-looking-picture-id1147811403?k=20&m=1147811403&s=612x612&w=0&h=lBbmmhPxES33OgnJgkzvtURRSs_gRvD7kX65gETQ9r8=",
  'https://media.istockphoto.com/photos/beautiful-bride-wedding-with-makeup-and-curly-hairstyle-stylist-picture-id518203028?b=1&k=20&m=518203028&s=170667a&w=0&h=optK90PYc80PQ5VQZdZp77ur1sgQoQyt1j1JOWJx2_U=',
];

/// brand logos
const List<String> brands = [
  'https://findlogovector.com/wp-content/uploads/2019/03/vlcc-personal-care-logo-vector.png',
  'https://getvectorlogo.com/wp-content/uploads/2018/12/lakme-vector-logo.png',
  'https://www.cityhairandbeauty.co.uk/wp-content/uploads/2021/03/LOREAL.png',
  'https://www.sreelogo.com/wp-content/uploads/2021/04/Natural-Logo-design-free-download-for-sreelogo-01.jpg',
  'https://bolde.in/uploads/business_images/aff3.jpeg',
  'https://m.media-amazon.com/images/S/abs-image-upload-na/d/AmazonStores/A21TJRUUN4KGV/d024c4846f2bfe95d1164f963b7ecc67.w396.h396.png',
];

/// brand names
const List<String> brandNames = [
  'VLCC',
  'LAKMÉ',
  'L\'Oreal',
  'Natural',
  'Affinity',
  'BBlunt',
];

/// salon names
const List<String> salonNames = [
  'Lakme Salon',
  'Jawed Habibs Hair & Beauty Salon',
  'Shahnaz Husain Salon',
  'VLCC Salon',
  'Affinity Salon',
  'BBlunt Salon',
];

const List<Map<String, String>> topArtistsData = [
  {
    "id": "0",
    "image": "https://randomuser.me/api/portraits/men/9.jpg",
    "title": "Lorena Lies",
    "subtitle": "Hiar Designer",
    "desc":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  },
  {
    "id": "0",
    "image": "https://randomuser.me/api/portraits/women/60.jpg",
    "title": "Philo Marissa",
    "subtitle": "Bridal Makeup Artist",
    "desc":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  },
  {
    "id": "0",
    "image": "https://randomuser.me/api/portraits/women/23.jpg",
    "title": "Korneli Sherrie",
    "subtitle": "Hair dresser",
    "desc":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  },
  {
    "id": "0",
    "image": "https://randomuser.me/api/portraits/women/5.jpg",
    "title": "Liselotte Angelique",
    "subtitle": "Hair Designer",
    "desc":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  },
  {
    "id": "0",
    "image": "https://randomuser.me/api/portraits/women/50.jpg",
    "title": "Aristarchus Ami",
    "subtitle": "Hair Designer",
    "desc":
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
  },
];

const List<Map<String, String>> brandsData = [
  {
    "id": "0",
    "image":
        "https://im.idiva.com/content/2022/Jun/1-5-Salon-Grade-Hair-Products-For-Treating-Damaged-And-Rough-Hair_6299fa9061574.jpg?w=600&h=450&cc=1",
    "title": "L'Oreal",
  },
  {
    "id": "0",
    "image":
        "https://cdn2.stylecraze.com/wp-content/uploads/2013/11/2827-Top-10-Hair-Salon-Products-Available-In-India-.jpg",
    "title": "TRESemmé",
  },
  {
    "id": "0",
    "image":
        "https://cdn.shopify.com/s/files/1/0517/1868/4866/products/13063_NYM_Curl_Talk_Sculpting_Gel_0573_HERO_afcd9b1d-8967-4d9f-b03e-71fa1d8416d0_900x900.jpg?v=1631044362",
    "title": "L'Oreal",
  },
  {
    "id": "0",
    "image":
        "http://ii.beautybrands.com/fcgi-bin/iipsrv.fcgi?FIF=/images/beautybrands/source/7325_default.tif&wid=1000&cvt=jpeg",
    "title": "Hempz",
  },
];

const List<Map<String, dynamic>> whysUsData = [
  {
    "id": 0,
    "image": "assets/why_us_imgs/vaccine.png",
    "title": "Fully Vaccinated Staff",
    "desc": "Because we care for you and for our artists.",
  },
  {
    "id": 1,
    "image": "assets/why_us_imgs/gloves.png",
    "title": "One Time Use - Gloves",
    "desc": "Use and throw standard gloves to enhance precautionary measures.",
  },
  {
    "id": 2,
    "image": "assets/why_us_imgs/sos.png",
    "title": "SOS",
    "desc":
        "Our in-built safety verification mechanism to ensure utmost security.",
  },
  {
    "id": 3,
    "image": "assets/why_us_imgs/social-care.png",
    "title": "Personal Care",
    "desc": "Artists are trained to take personal health & hygiene care.",
  },
  {
    "id": 4,
    "image": "assets/why_us_imgs/experience.png",
    "title": "Trained and experienced artists",
    "desc":
        "Full fledged on-job trained and experienced artists. Branded cosmetics used to glam you up!",
  },
  {
    "id": 5,
    "image": "assets/why_us_imgs/warranty.png",
    "title": "India’s premier Studios",
    "desc":
        "You can choose to hire professional artists from India’s premier Makeup & Glam Studios.",
  },
];
