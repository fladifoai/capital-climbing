import { HashRouter, Routes, Route, Navigate } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import { AuthProvider } from '../features/auth/AuthContext'
import AuthGuard from '../components/AuthGuard'
import AdminGuard from '../components/AdminGuard'
import Layout from '../components/Layout'
import LoginPage from '../routes/LoginPage'
import RegisterPage from '../routes/RegisterPage'
import ForgotPasswordPage from '../routes/ForgotPasswordPage'
import CheckEmailPage from '../routes/CheckEmailPage'
import ExplorePage from '../routes/ExplorePage'
import RegionPage from '../routes/RegionPage'
import CragDetailPage from '../routes/CragDetailPage'
import RouteDetailPage from '../routes/RouteDetailPage'
import UsersPage from '../routes/UsersPage'
import UserProfilePage from '../routes/UserProfilePage'
import DashboardPage from '../routes/DashboardPage'
import MyRoutesPage from '../routes/MyRoutesPage'
import SessionsPage from '../routes/SessionsPage'
import ProjectsPage from '../routes/ProjectsPage'
import AnalyticsPage from '../routes/AnalyticsPage'
import SettingsPage from '../routes/SettingsPage'
import AdminPage from '../routes/AdminPage'
import AdminCragPage from '../routes/AdminCragPage'
import AdminImportPage from '../routes/AdminImportPage'
import LandingPage from '../routes/LandingPage'

const queryClient = new QueryClient()

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <HashRouter>
        <AuthProvider>
          <Routes>
            {/* Landing pubblica — senza layout */}
            <Route path="/" element={<LandingPage />} />

            {/* Pagine auth — senza layout */}
            <Route path="/login" element={<LoginPage />} />
            <Route path="/register" element={<RegisterPage />} />
            <Route path="/forgot-password" element={<ForgotPasswordPage />} />
            <Route path="/check-email" element={<CheckEmailPage />} />

            {/* Pagine con layout */}
            <Route element={<Layout />}>
              {/* Pubbliche — accessibili senza account */}
              <Route path="/explore" element={<ExplorePage />} />
              <Route path="/regions/:regionId" element={<RegionPage />} />
              <Route path="/crags/:cragId" element={<CragDetailPage />} />
              <Route path="/routes/:routeId" element={<RouteDetailPage />} />
              <Route path="/users" element={<UsersPage />} />
              <Route path="/u/:username" element={<UserProfilePage />} />

              {/* Private — richiedono login */}
              <Route element={<AuthGuard />}>
                <Route path="/dashboard" element={<DashboardPage />} />
                <Route path="/my-routes" element={<MyRoutesPage />} />
                <Route path="/sessions" element={<SessionsPage />} />
                <Route path="/projects" element={<ProjectsPage />} />
                <Route path="/analytics" element={<AnalyticsPage />} />
                <Route path="/settings" element={<SettingsPage />} />
              </Route>

              {/* Admin — richiedono ruolo admin */}
              <Route element={<AdminGuard />}>
                <Route path="/admin" element={<AdminPage />} />
                <Route path="/admin/crags/:cragId" element={<AdminCragPage />} />
                <Route path="/admin/import" element={<AdminImportPage />} />
              </Route>
            </Route>

            <Route path="*" element={<Navigate to="/" replace />} />
          </Routes>
        </AuthProvider>
      </HashRouter>
    </QueryClientProvider>
  )
}
