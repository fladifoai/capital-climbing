import { useParams } from 'react-router-dom'

export default function RouteDetailPage() {
  const { routeId } = useParams()
  return <div className="page-placeholder"><h1>Via {routeId}</h1></div>
}
