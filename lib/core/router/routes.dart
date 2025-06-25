const publicRoutes = {
  '/login',
  '/register',
  '/welcome',
  '/unboarding',
  '/debug',
  '/articles',
  '/activities',
  '/activity',
  '/home',
  '/profile',
  '/article',
};

const roleAllowed = {
  'Admin': <String>{
    '/home',
    '/articles',
    '/activities',
    '/activity',
    '/activity/create',
    '/categories',
    '/category/create',
    '/category',
    '/users',
    '/user/create',
    '/user',
    '/profile',
    '/article',
  },
  'User': <String>{
    '/home',
    '/articles',
    '/activities',
    '/activity',
    '/profile',
    '/article',
  },
};