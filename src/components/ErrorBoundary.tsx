import { Component, type ReactNode } from 'react'

interface Props { children: ReactNode }
interface State { error: Error | null; componentStack: string | null }

export default class ErrorBoundary extends Component<Props, State> {
  state: State = { error: null, componentStack: null }

  static getDerivedStateFromError(error: Error): State {
    return { error, componentStack: null }
  }

  componentDidCatch(_error: Error, info: { componentStack: string }) {
    this.setState({ componentStack: info.componentStack })
  }

  render() {
    if (this.state.error) {
      return (
        <div style={{ padding: 32, color: '#c0392b', fontFamily: 'monospace', fontSize: 13 }}>
          <strong>Errore di rendering:</strong>
          <pre style={{ marginTop: 8, whiteSpace: 'pre-wrap' }}>{this.state.error.message}</pre>
          {this.state.componentStack && (
            <>
              <strong style={{ marginTop: 16, display: 'block' }}>Component stack:</strong>
              <pre style={{ marginTop: 4, whiteSpace: 'pre-wrap', fontSize: 11, color: '#666' }}>
                {this.state.componentStack}
              </pre>
            </>
          )}
        </div>
      )
    }
    return this.props.children
  }
}
