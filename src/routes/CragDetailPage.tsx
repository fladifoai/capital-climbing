import { useParams } from 'react-router-dom'

export default function CragDetailPage() {
  const { cragId } = useParams()
  return <div className="page-placeholder"><h1>Falesia {cragId}</h1></div>
}
