const publicRoutes = {
  '/login',
  '/register',
  '/welcome',
  '/unboarding',
  '/debug',
  '/search',
  '/activities',
  '/activity',
  '/home',
  '/profile'
};

const roleAllowed = {
  'Admin': <String>{
    '/home',
    '/search',
    '/activities',
    '/activity',
    '/activity/create',
    '/categories',
    '/category/create',
    '/category',
    '/users',
    '/user/create',
    '/profile',
  },
  'User': <String>{
    '/home',
    '/search',
    '/activities',
    '/activity',
    '/profile',
  },
};