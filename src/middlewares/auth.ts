import jwt from "jsonwebtoken";
import logger from "../utils/logger";

function isAuthenticated(req: Request, res: Response, next: NextFunction) {
    const { authorization } = req.headers;

    if (!authorization) {
        res.sendStatus(401);
    }

    try {
        const token = authorization.split(' ')[1];
        const payload = jwt.verify(token, process.env.JWT_ACCESS_SECRET);
        reqpayload = payload;
        next();
    } catch (err) {
        logger(err);
        res.status(401).send(err.name);
    }
}

export { isAuthenticated };
