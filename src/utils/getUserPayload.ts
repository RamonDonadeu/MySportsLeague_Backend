
export default function getUserPayload(req: Request) {
    const { authorization } = req.headers;
    const token = authorization.split(' ')[1];
    const payload = jwt.verify(token, process.env.JWT_ACCESS_SECRET);
    return payload;

}