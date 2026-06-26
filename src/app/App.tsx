import { HashRouter, Routes, Route, Navigate } from 'react-router-dom'
import { QueryClient, QueryClientProvider } from '@tanstack/react-query'
import Layout from '../components/Layout'
import LoginPage from '../routes/LoginPage'
import RegisterPage from '../routes/RegisterPage'
import DashboardPage from '../routes/DashboardPage'
import ExplorePage from '../routes/ExplorePage'
import CragDetailPage from '../routes/CragDetailPage'
import RouteDetailPage from '../routes/RouteDetailPage'
import MyRoutesPage from '../routes/MyRoutesPage'
import SessionsPage from '../routes/SessionsPage'
import ProjectsPage from '../routes/ProjectsPage'
import AnalyticsPage from '../routes/AnalyticsPage'
import UsersPage from '../routes/UsersPage'
import UserProfilePage from '../routes/UserProfilePage'
import SettingsPage from '../routes/SettingsPage'
import AdminPage from '../routes/AdminPage'
import AdminImportPage from '../routes/AdminImportPage'

const queryClient = new QueryClient()

export default function App() {
  return (
    <QueryClientProvider client={queryClient}>
      <HashRouter>
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/register" element={<RegisterPage />} />
          <Route element={<Layout />}>
            <Route path="/dashboard" element={<DashboardPage />} />
            <Route path="/explore" element={<ExplorePage />} />
            <Route path="/crags/:cragId" element={<CragDetailPage />} />
            <Route path="/routes/:routeId" element={<RouteDetailPage />} />
            <Route path="/my-routes" element={<MyRoutesPage />} />
            <Route path="/sessions" element={<SessionsPage />} />
            <Route path="/projects" element={<ProjectsPage />} />
            <Route path="/analytics" element={<AnalyticsPage />} />
            <Route path="/users" element={<UsersPage />} />
            <Route path="/u/:username" element={<UserProfilePage />} />
            <Route path="/settings" element={<SettingsPage />} />
            <Route path="/admin" element={<AdminPage />} />
            <Route path="/admin/import" element={<AdminImportPage />} />
          </Route>
          <Route path="*" element={<Navigate to="/dashboard" replace />} />
        </Routes>
      </HashRouter>
    </QueryClientProvider>
  )
}
