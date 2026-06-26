import { useParams } from 'react-router-dom'

export default function UserProfilePage() {
  const { username } = useParams()
  return <div className="page-placeholder"><h1>Profilo di {username}</h1></div>
}
